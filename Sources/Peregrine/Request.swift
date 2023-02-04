import Foundation

public struct Request: Transferable {
    public let type: TransferableType = .data
    public let data: Data

    internal init(data: Data) {
        self.data = data
    }
}
