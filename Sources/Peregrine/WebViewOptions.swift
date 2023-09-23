public struct WebViewScrollViewOptions {
    public var bounces = false
}

public struct WebViewOptions {
    public let scrollView = WebViewScrollViewOptions()

    public init() {}
}
