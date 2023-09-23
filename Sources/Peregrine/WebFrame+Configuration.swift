import Foundation

extension WebFrame {
    public final class Configuration {
        /// The URL from which to load HTML.
        ///
        /// If `baseURL` is a file URL, the files are loaded from the device at
        /// the specified URL using the built-in `app://` server. Otherwise,
        /// files are loaded from the specified URL as remote resources.
        public let baseURL: URL
        public let functions: RemoteFunctions?
        public let observables: RemoteObservables?
        public let pathHandlers: [String: PathHandler]?
        public let webViewOptions = WebViewOptions()

        internal static let appScheme = "app"
        internal static let rpcScheme = "peregrine"

        internal var appURL: URL {
            if baseURL.isFileURL {
                let indexPath = "\(Configuration.appScheme):///"
                return URL(string: indexPath)! // swiftlint:disable:this force_unwrapping
            } else {
                return baseURL
            }
        }

        internal var allowedOrigin: String {
            if baseURL.isFileURL {
                return "\(Configuration.appScheme)://"
            } else {
                return baseURL.absoluteString
            }
        }

        internal var namespace: String { Bundle.main.bundleIdentifier ?? "global" }
        internal var queueLabel: String { "\(namespace).peregrine" }

        public init(
            baseURL: URL = Bundle.main.url(
                forResource: "www",
                withExtension: nil
            )!, // swiftlint:disable:this force_unwrapping
            functions: RemoteFunctions? = nil,
            observables: RemoteObservables? = nil,
            pathHandlers: [String: PathHandler]? = nil
        ) {
            self.baseURL = baseURL
            self.functions = functions
            self.observables = observables
            self.pathHandlers = pathHandlers
        }
    }
}
