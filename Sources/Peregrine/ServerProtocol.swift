import Foundation

internal typealias Headers = [String: String]

internal protocol ServerResponseHandler {
    func didReceive(response: URLResponse)
    func didReceive(bytes: Data)
    func didFinish()
}

internal protocol ServerProtocol {
    func respond(to: URLRequest, usingHandler: ServerResponseHandler)
    func stopResponding(to: URLRequest)
}
