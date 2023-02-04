import Foundation

public struct Call {
    public let request: Request
    internal let didRespond: (Response) -> Void

    internal init(request: Request, didRespond: @escaping (Response) -> Void) {
        self.request = request
        self.didRespond = didRespond
    }

    public func respond() {
        respond(with: Data())
    }

    public func respond(with data: Data) {
        respond(Response(data, status: .success))
    }

    public func respond(with text: String) {
        respond(Response(text, status: .success))
    }

    public func respond<T: Encodable>(with json: T) throws {
        respond(try Response(json, status: .success))
    }

    public func fail(_ message: String?, code: String? = nil) {
        fail(with: CallError(message ?? "Error", code: code))
    }

    internal func respond(_ response: Response) {
        didRespond(response)
    }

    internal func fail(with error: CallError) {
        let response = try! Response( // swiftlint:disable:this force_try
            error,
            status: .error
        )

        respond(response)
    }
}
