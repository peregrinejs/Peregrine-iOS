public struct WebViewScrollViewOptions {
    public let bounces: Bool
    
    public init(
        bounces: Bool = false
    ) {
        self.bounces = bounces
    }
}

public struct WebViewOptions {
    public let scrollView: WebViewScrollViewOptions
    
    public init(scrollView: WebViewScrollViewOptions = WebViewScrollViewOptions()) {
        self.scrollView = scrollView
    }
}
