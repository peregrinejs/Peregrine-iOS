import Foundation

public struct Event: Transferable {
    public let type: TransferableType = .json
    public let data: Data

    public init() {
        data = Data()
    }

    public init?<T: Encodable>(_ json: T) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        do {
            data = try encoder.encode(json)
        } catch {
            return nil
        }
    }
}
