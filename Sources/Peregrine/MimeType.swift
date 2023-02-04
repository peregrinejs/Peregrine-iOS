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
