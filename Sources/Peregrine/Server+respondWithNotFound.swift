import Foundation

extension Server {
    internal func respondWithNotFound(
        to request: URLRequest,
        message: String,
        usingHandler handler: ServerResponseHandler
    ) {
        respondWithMessage(
            to: request,
            message: message,
            statusCode: 404,
            usingHandler: handler
        )
    }
}
