extension Response {
    internal var statusCode: Int {
        switch status {
        case .success:
            return 200
        case .error:
            return 400
        }
    }
}
