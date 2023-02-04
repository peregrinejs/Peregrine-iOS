import Foundation

extension RPCServer {
    internal struct Configuration {
        internal let scheme: String
        internal let allowedOrigin: String
        internal let functions: RemoteFunctions?
        internal let observables: RemoteObservables?
        internal let pathMatchers: [PathMatcher]?
        internal let baseURL: URL

        internal init(
            scheme: String,
            allowedOrigin: String,
            functions: RemoteFunctions?,
            observables: RemoteObservables?,
            pathHandlers: [String: PathHandler]?
        ) {
            self.scheme = scheme
            self.allowedOrigin = allowedOrigin
            self.functions = functions
            self.observables = observables

            let baseURL = URL(string: "\(scheme):///")! // swiftlint:disable:this force_unwrapping
            let userBaseURL = baseURL.appendingPathComponent(userNamespace)

            if let handlers = pathHandlers {
                self.pathMatchers = handlers.map { (path, pathHandler) in
                    return PathMatcher(
                        baseURL: userBaseURL.appendingPathComponent(path),
                        handler: pathHandler
                    )
                }
            } else {
                self.pathMatchers = nil
            }

            self.baseURL = baseURL
        }
    }
}
