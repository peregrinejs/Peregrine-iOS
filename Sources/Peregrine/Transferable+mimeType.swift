extension Transferable {
    internal var mimeType: MimeType {
        switch type {
        case .data:
            return MimeType.binary(nil)
        case .text:
            return MimeType.text(nil)
        case .json:
            return MimeType.text("application/json")
        }
    }
}
