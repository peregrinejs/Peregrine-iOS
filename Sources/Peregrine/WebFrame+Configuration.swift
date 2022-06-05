// Peregrine for iOS: native container for hybrid apps
// Copyright (C) 2022 Caracal LLC
//
// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License version 3 as published
// by the Free Software Foundation.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License version 3
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import Foundation

extension WebFrame {
    public final class Configuration {
        /// The URL from which to load HTML.
        ///
        /// If `baseURL` is a file URL, the files are loaded from the device at the
        /// specified URL using the built-in `app://` server. Otherwise, files are
        /// loaded from the specified URL as remote resources.
        public let baseURL: URL
        public let remoteInterface: RemoteInterface?
        public let pathHandlers: [String: PathHandler]?

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
            remoteInterface: RemoteInterface? = nil,
            pathHandlers: [String: PathHandler]? = nil
        ) {
            self.baseURL = baseURL
            self.remoteInterface = remoteInterface
            self.pathHandlers = pathHandlers
        }
    }
}
