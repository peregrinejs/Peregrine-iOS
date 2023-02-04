extension Transferable {
    public var text: String {
        String(decoding: data, as: UTF8.self)
    }
}
