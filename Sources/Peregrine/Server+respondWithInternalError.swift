import Foundation

extension Server {
    internal func respondWithInternalError(
        to request: URLRequest,
        message: String,
        usingHandler handler: ServerResponseHandler
    ) {
        respondWithMessage(
            to: request,
            message: message,
            statusCode: 500,
            usingHandler: handler
        )
    }
}
