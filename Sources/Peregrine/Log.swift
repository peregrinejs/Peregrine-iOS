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

internal enum LogLevel: String, CustomStringConvertible {
    case error
    case warn
    case info
    case debug

    var description: String {
        switch self {
        case .error:
            return "\u{1F6A8} \(rawValue.uppercased()) \u{1F6A8}"
        default:
            return rawValue
        }
    }
}

let dateFormatter = ISO8601DateFormatter()

internal func log(_ message: String, level: LogLevel = .info) {
    let date = Date()
    let message =
        "Peregrine: \(dateFormatter.string(from: date)) \(String(describing: level)): \(message)"

    print(message)
}
