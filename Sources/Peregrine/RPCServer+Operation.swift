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
