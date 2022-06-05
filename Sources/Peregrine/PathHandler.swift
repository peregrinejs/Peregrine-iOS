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

public struct PathHandlerResponse {
    let statusCode: Int
    let responseHeaders: [String: String]
    let data: Data
}

public protocol PathHandler {
    func handle(path: String) -> PathHandlerResponse
}

public class InternalStoragePathHandler: PathHandler {
    let directory: URL

    public init(directory: URL) {
        self.directory = directory
    }

    public func handle(path: String) -> PathHandlerResponse {
        let url = directory.appendingPathComponent(path)
        let bytes: Data
        let mimeType: MimeType
        let statusCode: Int

        do {
            bytes = try Data(contentsOf: url)
            mimeType = MimeType(forExtension: url.pathExtension)
            statusCode = 200
        } catch {
            mimeType = MimeType.text(nil)
            bytes = Data("Not Found".utf8)
            statusCode = 404
        }

        let headers = mimeType.headers
            .merging(bytes.headers) { $1 }

        return PathHandlerResponse(
            statusCode: statusCode,
            responseHeaders: headers,
            data: bytes
        )
    }
}
