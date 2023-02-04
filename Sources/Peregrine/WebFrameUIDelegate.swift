import WebKit

internal class WebFrameUIDelegate: NSObject, WKUIDelegate, ObservableObject {
    internal weak var frame: WebFrame?

    private var _frame: WebFrame {
        guard let frame = frame else {
            fatalError("WebFrameUIDelegate lost reference to WebFrame.")
        }

        return frame
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo
    ) async {
        fatalError("WebFrameUIDelegate has no alert handler configured.")
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo
    ) async -> Bool {
        fatalError("WebFrameUIDelegate has no confirm handler configured.")
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo
    ) async -> String? {
        fatalError("WebFrameUIDelegate has no text input handler configured.")
    }
}
