import Foundation

public enum TransferableType {
    case data
    case text
    case json
}

public protocol Transferable {
    var type: TransferableType { get }
    var data: Data { get }
}
