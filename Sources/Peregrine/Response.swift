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

internal enum ResponseStatus {
    case success
    case error
}

internal struct Response: Transferable {
    internal let type: TransferableType
    internal let data: Data
    internal let status: ResponseStatus

    internal init(_ data: Data, status: ResponseStatus) {
        type = .data
        self.data = data
        self.status = status
    }

    internal init(_ text: String, status: ResponseStatus) {
        type = .text
        data = Data(text.utf8)
        self.status = status
    }

    internal init<T: Encodable>(_ json: T, status: ResponseStatus) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        type = .json
        data = try encoder.encode(json)
        self.status = status
    }
}
