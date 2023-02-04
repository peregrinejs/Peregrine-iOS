import Foundation

internal enum LogLevel: String, CustomStringConvertible {
    case error
    case warn
    case info
    case debug

    var description: String {
        switch self {
        case .error:
            return "\u{1F6A8} \(rawValue.uppercased()) \u{1F6A8}"
        default:
            return rawValue
        }
    }
}

let dateFormatter = ISO8601DateFormatter()

internal func log(_ message: String, level: LogLevel = .info) {
    let date = Date()
    let message =
        "Peregrine: \(dateFormatter.string(from: date)) \(String(describing: level)): \(message)"

    print(message)
}
