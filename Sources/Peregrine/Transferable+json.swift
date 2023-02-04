import Foundation

extension Transferable {
    public func json<T: Decodable>(_ type: T.Type) throws -> T {
        return try JSONDecoder().decode(type, from: data)
    }
}
