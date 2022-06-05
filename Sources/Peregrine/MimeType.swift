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

internal enum MimeType {
    case binary(String?)
    case text(String?)

    var mimeType: String {
        switch self {
        case let .binary(binaryType):
            guard let type = binaryType else {
                return "application/octet-stream"
            }

            return type
        case let .text(textType):
            guard let type = textType else {
                return "text/plain"
            }

            return type
        }
    }

    var contentType: String {
        switch self {
        case .text:
            return "\(mimeType); charset=utf-8"
        default:
            return mimeType
        }
    }

    var headers: Headers {
        return ["Content-Type": contentType]
    }
}
