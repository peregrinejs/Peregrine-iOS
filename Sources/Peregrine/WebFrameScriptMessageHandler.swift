import WebKit

internal class WebFrameScriptMessageHandler: NSObject, WKScriptMessageHandlerWithReply {
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage,
        replyHandler: @escaping (Any?, String?) -> Void
    ) {
        fatalError("WebFrameScriptMessageHandler does not yet handle messages.")
    }
}
