import Foundation

internal struct CallError: Encodable {
    internal let message: String
    internal let code: String?

    internal init(_ message: String, code: String? = nil) {
        self.message = message
        self.code = code
    }
}
