import Foundation

internal class PathMatcher {
    internal let baseURL: URL
    internal let handler: PathHandler

    internal init(baseURL: URL, handler: PathHandler) {
        self.baseURL = baseURL
        self.handler = handler
    }

    internal func matches(url: URL) -> Bool {
        if baseURL.scheme != url.scheme {
            return false
        }

        if baseURL.host != url.host {
            return false
        }

        return url.path.starts(with: baseURL.path)
    }

    internal func handle(url: URL) -> PathHandlerResponse {
        let pathComponents = url.pathComponents[baseURL.pathComponents.count...]
        let path = pathComponents.joined(separator: "/")

        return handler.handle(path: path)
    }
}
