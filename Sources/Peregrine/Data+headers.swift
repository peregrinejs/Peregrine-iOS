import Foundation

internal extension Data {
    var headers: Headers {
        return ["Content-Length": "\(count)"]
    }
}
