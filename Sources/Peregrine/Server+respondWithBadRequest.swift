import Foundation

extension Server {
    internal func respondWithBadRequest(
        to request: URLRequest,
        message: String,
        usingHandler handler: ServerResponseHandler
    ) {
        respondWithMessage(
            to: request,
            message: message,
            statusCode: 400,
            usingHandler: handler
        )
    }
}
