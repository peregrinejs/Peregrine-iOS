extension RPCServer {
    internal enum OperationError: Error {
        case unknownNamespace(String)
        case unknownOperation(String)
    }
}
