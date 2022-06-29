// Peregrine for iOS: native container for hybrid apps
// Copyright (C) 2022 Caracal LLC
//
// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License version 3 as published
// by the Free Software Foundation.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License version 3
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import Combine
import Foundation

internal final class RPCServer: Server, ServerProtocol {
    internal static let rpcNamespace: String = "__rpc__"
    internal static let userNamespace: String = "__user__"

    internal let configuration: Configuration

    private var subscriptionRequest: URLRequest?
    private var subscriptionHandler: ServerResponseHandler?
    private var subscriptions: Set<AnyCancellable> = Set()

    internal init(configuration: Configuration) {
        self.configuration = configuration
        super.init()
    }

    override internal func headers() -> Headers {
        let baseHeaders = super.headers()
        let headers = [
            "Access-Control-Allow-Origin": configuration.allowedOrigin
        ]

        return headers.merging(baseHeaders) { $1 }
    }

    private func operation(
        fromRequest request: URLRequest,
        usingHandler handler: ServerResponseHandler
    ) -> Operation? {
        do {
            return try Operation(request: request)
        } catch let OperationError.unknownNamespace(namespace) {
            respondWithNotFound(
                to: request,
                message: "Unknown namespace: \(namespace)",
                usingHandler: handler
            )
        } catch let OperationError.unknownOperation(operation) {
            respondWithNotFound(
                to: request,
                message: "Unknown RPC operation: \(operation)",
                usingHandler: handler
            )
        } catch {
            log(
                """
                Unknown error: \(String(describing: error))
                """,
                level: .error
            )

            respondWithInternalError(
                to: request,
                message: "Internal Server Error",
                usingHandler: handler
            )
        }

        return nil
    }

    internal func respond(
        to request: URLRequest,
        usingHandler handler: ServerResponseHandler
    ) {
        guard let operation = operation(fromRequest: request, usingHandler: handler) else {
            return
        }

        switch operation {
        case let .invoke(method, body):
            invoke(method: method, with: body) { response in
                self.respond(
                    to: request,
                    with: response,
                    usingHandler: handler
                )
            }
        case .subscribe:
            subscribe(request: request, usingHandler: handler)
        case let .user(url):
            guard let matchers = configuration.pathMatchers else {
                respondWithNotFound(
                    to: request,
                    message: "No path handlers registered.",
                    usingHandler: handler
                )

                return
            }

            guard let matcher = matchers.first(where: { $0.matches(url: url) }) else {
                respondWithNotFound(
                    to: request,
                    message: "No path handler found for URL: \(url.absoluteString).",
                    usingHandler: handler
                )

                return
            }

            respond(
                to: url,
                usingMatcher: matcher,
                usingHandler: handler
            )
        }
    }

    private func respond(
        to request: URLRequest,
        with response: Response,
        usingHandler handler: ServerResponseHandler
    ) {
        let url = request.url! // swiftlint:disable:this force_unwrapping
        let httpHeaders = headers()
            .merging(response.data.headers) { $1 }
            .merging(response.mimeType.headers) { $1 }

        let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: response.statusCode,
            httpVersion: nil,
            headerFields: httpHeaders
        )! // swiftlint:disable:this force_unwrapping

        respond(
            response: httpResponse,
            body: response.data,
            usingHandler: handler
        )
    }

    private func respond(
        to url: URL,
        usingMatcher matcher: PathMatcher,
        usingHandler handler: ServerResponseHandler
    ) {
        let response = matcher.handle(url: url)

        let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: response.statusCode,
            httpVersion: nil,
            headerFields: headers().merging(response.responseHeaders) { $1 }
        )! // swiftlint:disable:this force_unwrapping

        respond(
            response: httpResponse,
            body: response.data,
            usingHandler: handler
        )
    }

    internal func stopResponding(to request: URLRequest) {
        if request == subscriptionRequest {
            subscriptionHandler = nil
            subscriptionRequest = nil
        }
    }

    private func invoke(
        method methodKey: String,
        with body: Data,
        didReceive: @escaping (Response) -> Void
    ) {
        let call = Call(request: Request(data: body)) { response in
            didReceive(response)
        }

        guard let functions = configuration.functions, let method = functions[methodKey] else {
            call.fail(
                "Unknown function: \(methodKey)",
                code: RPCError.unknownMethod.description
            )

            return
        }

        method(call)
    }

    private func subscribe(
        request: URLRequest,
        usingHandler handler: ServerResponseHandler
    ) {
        let url = request.url! // swiftlint:disable:this force_unwrapping
        let httpHeaders = headers()
            .merging(["Content-Type": "text/event-stream"]) { $1 }
        let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: httpHeaders
        )! // swiftlint:disable:this force_unwrapping

        handler.didReceive(response: httpResponse)

        subscriptionRequest = request
        subscriptionHandler = handler

        for (observableName, observable) in configuration.observables ?? [:] {
            observable
                .dropFirst()
                .filter { $0 != nil }
                .receive(on: RunLoop.main)
                .sink { event in
                    self.handle(
                        event: event!, // swiftlint:disable:this force_unwrapping
                        with: observableName
                    )
                }
                .store(in: &subscriptions)
        }
    }

    private func handle(event: Event, with key: String) {
        let value = event.data

        guard let handler = subscriptionHandler else {
            // TODO: this isn't possible anymore: remove or refactor

            let decodedValue = String(decoding: value, as: UTF8.self)

            log(
                """
                Observable '\(key)' sent value '\(decodedValue)' while the \
                subscription connection was not active (likely because it was \
                not yet established). This value will not be delivered to the \
                client.
                """,
                level: .warn
            )

            return
        }

        let bytes = (
            Data("data: \(key)".utf8) +
                value +
                Data("\n\n".utf8)
        )

        handler.didReceive(bytes: bytes)

        log(
            """
            Observable '\(key)' sent \(value.count) bytes.
            """,
            level: .debug
        )
    }
}
