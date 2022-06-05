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
