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
