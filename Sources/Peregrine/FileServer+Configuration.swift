import Foundation

extension FileServer {
    internal struct Configuration {
        internal let scheme: String
        internal let baseURL: URL

        internal init(
            scheme: String,
            baseURL: URL
        ) {
            self.scheme = scheme
            self.baseURL = baseURL
        }
    }
}
