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

public struct Call {
    public let request: Request
    internal let didRespond: (Response) -> Void

    internal init(request: Request, didRespond: @escaping (Response) -> Void) {
        self.request = request
        self.didRespond = didRespond
    }

    public func respond() {
        respond(with: Data())
    }

    public func respond(with data: Data) {
        respond(Response(data, status: .success))
    }

    public func respond(with text: String) {
        respond(Response(text, status: .success))
    }

    public func respond<T: Encodable>(with json: T) throws {
        respond(try Response(json, status: .success))
    }

    public func fail(_ message: String?, code: String? = nil) {
        fail(with: CallError(message ?? "Error", code: code))
    }

    internal func respond(_ response: Response) {
        didRespond(response)
    }

    internal func fail(with error: CallError) {
        let response = try! Response( // swiftlint:disable:this force_try
            error,
            status: .error
        )

        respond(response)
    }
}
