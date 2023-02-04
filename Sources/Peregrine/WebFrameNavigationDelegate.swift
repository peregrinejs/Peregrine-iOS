import WebKit

internal class WebFrameNavigationDelegate: NSObject, WKNavigationDelegate {
    internal weak var frame: WebFrame?
    internal weak var initialNavigation: WKNavigation?

    private var _frame: WebFrame {
        guard let frame = frame else {
            fatalError("WebFrameNavigationDelegate lost reference to WebFrame.")
        }

        return frame
    }

    func webView(
        _: WKWebView,
        // swiftlint:disable:next line_length
        didFailProvisionalNavigation navigation: WKNavigation!, // swiftlint:disable:this implicitly_unwrapped_optional
        withError error: Error
    ) {
        let message =
            "WebFrame provisional navigation failed: \(String(describing: error))"

        if navigation == initialNavigation {
            fatalError(message)
        } else {
            log(message, level: .error)
        }
    }

    func webView(
        _: WKWebView,
        didFail navigation: WKNavigation!, // swiftlint:disable:this implicitly_unwrapped_optional
        withError error: Error
    ) {
        let message = "WebFrame navigation failed: \(String(describing: error))"

        if navigation == initialNavigation {
            fatalError(message)
        } else {
            log(message, level: .error)
        }
    }

    func webView(
        _: WKWebView,
        didFinish navigation: WKNavigation! // swiftlint:disable:this implicitly_unwrapped_optional
    ) {
        if navigation == initialNavigation {
            log("WebFrame loaded initial navigation.", level: .info)
        }
    }

    func webView(
        _: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        let appURL = _frame.configuration.appURL

        // Cancel navigation if the request doesn't have a valid URL
        guard let requestURL = navigationAction.request.url,
              let requestScheme = requestURL.scheme
        else {
            decisionHandler(.cancel)
            return
        }

        // Allow navigation to the base URL
        if requestScheme == appURL.scheme, requestURL.host == appURL.host {
            decisionHandler(.allow)
            return
        }
        // Allow navigation if the target frame is not the WebView
        else if let targetFrame = navigationAction.targetFrame, !targetFrame.isMainFrame {
            decisionHandler(.allow)
            return
        }
        // Otherwise, open the URL as an external link and cancel navigation
        else {
            if UIApplication.shared.applicationState == .active {
                UIApplication.shared.open(
                    requestURL,
                    options: [:],
                    completionHandler: nil
                )
            }

            decisionHandler(.cancel)
        }
    }
}
