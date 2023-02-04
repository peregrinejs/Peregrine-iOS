import SwiftUI
import WebKit

public struct WebFrameRepresentable: UIViewRepresentable {
    public let frame: WebFrame

    public typealias UIViewType = WKWebView

    public func makeUIView(context _: Context) -> WKWebView {
        let webView = frame.webView
        frame.loadBaseURL()
        return webView
    }

    public func updateUIView(_: WKWebView, context _: Context) {}
}
