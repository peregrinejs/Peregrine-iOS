import Foundation

public struct PathHandlerResponse {
    let statusCode: Int
    let responseHeaders: [String: String]
    let data: Data
}

public protocol PathHandler {
    func handle(path: String) -> PathHandlerResponse
}

public class InternalStoragePathHandler: PathHandler {
    let directory: URL

    public init(directory: URL) {
        self.directory = directory
    }

    public func handle(path: String) -> PathHandlerResponse {
        let url = directory.appendingPathComponent(path)
        let bytes: Data
        let mimeType: MimeType
        let statusCode: Int

        do {
            bytes = try Data(contentsOf: url)
            mimeType = MimeType(forExtension: url.pathExtension)
            statusCode = 200
        } catch {
            mimeType = MimeType.text(nil)
            bytes = Data("Not Found".utf8)
            statusCode = 404
        }

        let headers = mimeType.headers
            .merging(bytes.headers) { $1 }

        return PathHandlerResponse(
            statusCode: statusCode,
            responseHeaders: headers,
            data: bytes
        )
    }
}
