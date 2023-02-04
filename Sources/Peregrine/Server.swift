import Foundation

internal class Server {
    internal func headers() -> Headers {
        return [
            "Cache-Control": "no-cache",
            "Server": "Peregrine"
        ]
    }

    internal func respondWithMessage(
        to request: URLRequest,
        message: String,
        statusCode: Int,
        usingHandler handler: ServerResponseHandler
    ) {
        let url = request.url! // swiftlint:disable:this force_unwrapping
        let bytes = Data(message.utf8)
        let httpHeaders = headers()
            .merging(bytes.headers) { $1 }
            .merging(MimeType.text(nil).headers) { $1 }

        let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: httpHeaders
        )! // swiftlint:disable:this force_unwrapping

        respond(
            response: httpResponse,
            body: bytes,
            usingHandler: handler
        )
    }

    internal func respond(
        response: URLResponse,
        body bytes: Data,
        usingHandler handler: ServerResponseHandler
    ) {
        handler.didReceive(response: response)
        handler.didReceive(bytes: bytes)
        handler.didFinish()
    }
}
