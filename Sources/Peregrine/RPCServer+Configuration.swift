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
