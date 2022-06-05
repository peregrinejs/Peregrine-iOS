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
    internal enum Operation {
        case invoke(String, Data)
        case subscribe
        case user(URL)

        internal init(request: URLRequest) throws {
            let url = request.url! // swiftlint:disable:this force_unwrapping
            let namespace = url.pathComponents[1]

            switch namespace {
            case RPCServer.rpcNamespace:
                let operation = url.pathComponents[2]
                switch operation {
                case "invoke":
                    let method = url.pathComponents[3]
                    let body = request.httpBody ?? Data()
                    self = .invoke(method, body)
                case "subscribe":
                    self = .subscribe
                default:
                    throw OperationError.unknownOperation(operation)
                }
            case RPCServer.userNamespace:
                self = .user(url)
            default:
                throw OperationError.unknownNamespace(namespace)
            }
        }
    }
}
