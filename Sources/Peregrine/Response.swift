import Foundation

internal enum ResponseStatus {
    case success
    case error
}

internal struct Response: Transferable {
    internal let type: TransferableType
    internal let data: Data
    internal let status: ResponseStatus

    internal init(_ data: Data, status: ResponseStatus) {
        type = .data
        self.data = data
        self.status = status
    }

    internal init(_ text: String, status: ResponseStatus) {
        type = .text
        data = Data(text.utf8)
        self.status = status
    }

    internal init<T: Encodable>(_ json: T, status: ResponseStatus) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        type = .json
        data = try encoder.encode(json)
        self.status = status
    }
}
