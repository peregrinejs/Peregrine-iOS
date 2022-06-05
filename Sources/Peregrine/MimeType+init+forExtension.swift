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

import UniformTypeIdentifiers

extension MimeType {
    internal init(forExtension ext: String) {
        let types = UTType.types(
            tag: ext,
            tagClass: .filenameExtension,
            conformingTo: nil
        )

        guard let type = types.first,
              let preferredMIMEType = type.preferredMIMEType
        else {
            self = .binary(nil)
            return
        }

        if type.conforms(to: UTType.text) {
            self = .text(preferredMIMEType)
        } else {
            self = .binary(preferredMIMEType)
        }
    }
}
