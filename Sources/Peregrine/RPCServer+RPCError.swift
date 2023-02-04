extension RPCServer {
    internal enum RPCError: CustomStringConvertible {
        case unknownMethod

        var description: String {
            switch self {
            case .unknownMethod:
                return "PEREGRINE_UNKNOWN_METHOD"
            }
        }
    }
}
