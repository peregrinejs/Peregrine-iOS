import Foundation

internal final class FileServer: Server, ServerProtocol {
    internal let configuration: Configuration

    internal init(configuration: Configuration) {
        self.configuration = configuration
    }

    internal func respond(
        to request: URLRequest,
        usingHandler handler: ServerResponseHandler
    ) {
        let url = request.url! // swiftlint:disable:this force_unwrapping
        let path = normalize(path: url.path)
        let fileURL = configuration.baseURL.appendingPathComponent(
            path,
            isDirectory: false
        )

        respondWithFile(
            to: request,
            fileURL: fileURL,
            usingHandler: handler
        )
    }

    internal func stopResponding(to _: URLRequest) {}

    private func normalize(path: String) -> String {
        guard let lastCharacter = path.last else {
            return path
        }

        switch lastCharacter {
        case "/":
            return "\(path)index.html"
        default:
            return path
        }
    }

    private func respondWithFile(
        to request: URLRequest,
        fileURL: URL,
        usingHandler handler: ServerResponseHandler
    ) {
        guard let bytes = try? Data(contentsOf: fileURL) else {
            log(
                """
                File not found at '\(fileURL.absoluteString)'. Server will \
                respond with 404 Not Found.
                """,
                level: .warn
            )

            respondWithNotFound(
                to: request,
                message: "Not Found",
                usingHandler: handler
            )

            return
        }

        let url = request.url! // swiftlint:disable:this force_unwrapping
        let mimeType = MimeType(forExtension: fileURL.pathExtension)
        let httpHeaders = headers()
            .merging(bytes.headers) { $1 }
            .merging(mimeType.headers) { $1 }

        let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: httpHeaders
        )! // swiftlint:disable:this force_unwrapping

        respond(
            response: httpResponse,
            body: bytes,
            usingHandler: handler
        )
    }
}
