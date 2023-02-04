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
