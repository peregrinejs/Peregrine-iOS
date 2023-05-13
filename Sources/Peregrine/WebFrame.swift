import WebKit

public final class WebFrame: Frame {
    internal let configuration: Configuration
    internal let appServer: FileServer?
    internal let rpcServer: RPCServer

    internal var webView: WKWebView {
        if let webView = _webView {
            return webView
        }

        let (webView, _, _) = load()

        return webView
    }

    internal var webViewNavigationDelegate: WebFrameNavigationDelegate {
        if let webViewNavigationDelegate = _webViewNavigationDelegate {
            return webViewNavigationDelegate
        }

        let (_, webViewNavigationDelegate, _) = load()

        return webViewNavigationDelegate
    }

    internal var webViewUIDelegate: WebFrameUIDelegate {
        if let webViewUIDelegate = _webViewUIDelegate {
            return webViewUIDelegate
        }

        let (_, _, webViewUIDelegate) = load()

        return webViewUIDelegate
    }

    private var _webView: WKWebView?
    private var _webViewNavigationDelegate: WebFrameNavigationDelegate?
    private var _webViewUIDelegate: WebFrameUIDelegate?

    public init(configuration: Configuration) {
        self.configuration = configuration

        if configuration.baseURL.isFileURL {
            let appServerConfiguration = FileServer.Configuration(
                scheme: Configuration.appScheme,
                baseURL: configuration.baseURL
            )

            appServer = FileServer(configuration: appServerConfiguration)
        } else {
            appServer = nil
        }

        let rpcServerConfiguration = RPCServer.Configuration(
            scheme: Configuration.rpcScheme,
            allowedOrigin: configuration.allowedOrigin,
            functions: configuration.functions,
            observables: configuration.observables,
            pathHandlers: configuration.pathHandlers
        )

        rpcServer = RPCServer(configuration: rpcServerConfiguration)
    }

    public lazy var view: WebFrameRepresentable = {
        return WebFrameRepresentable(frame: self)
    }()

    /// Load the WebView and prepare for display.
    ///
    /// The WebView is lazy-loaded when either the `webView` or
    /// `webViewNavigationDelegate` properties is accessed. Usually, this
    /// happens during the lifecycles of `WebFrameRepresentable`. This avoids
    /// prematurely allocating resources and works around this bug:
    /// https://developer.apple.com/forums/thread/61432?answerId=174794022#174794022
    ///
    /// - Returns: An initialized Web View and its navigation delegate.
    private func load() -> (WKWebView, WebFrameNavigationDelegate, WebFrameUIDelegate) {
        if _webView != nil || _webViewNavigationDelegate != nil {
            fatalError("WebFrame refuses to initialize WebView twice.")
        }

        let queue = DispatchQueue(
            label: configuration.queueLabel,
            qos: .userInitiated
        )

        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true

        if let appServer = appServer {
            webViewConfiguration.setURLSchemeHandler(
                AppSchemeHandler(server: appServer, queue: queue),
                forURLScheme: appServer.configuration.scheme
            )
        }

        webViewConfiguration.setURLSchemeHandler(
            RPCSchemeHandler(server: rpcServer, queue: queue),
            forURLScheme: rpcServer.configuration.scheme
        )

        let scriptMessageHandler = WebFrameScriptMessageHandler()

        webViewConfiguration.userContentController = WKUserContentController()
        webViewConfiguration.userContentController.addScriptMessageHandler(
            scriptMessageHandler,
            contentWorld: WKContentWorld.page,
            name: "peregrine"
        )

        let webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        let webViewNavigationDelegate = WebFrameNavigationDelegate()
        let webViewUIDelegate = WebFrameUIDelegate()

        webView.allowsLinkPreview = false

        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        } else {
            // webviews are inspectable by default before 16.4
        }

        webView.navigationDelegate = webViewNavigationDelegate
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.uiDelegate = webViewUIDelegate

        webViewNavigationDelegate.frame = self
        webViewUIDelegate.frame = self

        _webView = webView
        _webViewNavigationDelegate = webViewNavigationDelegate
        _webViewUIDelegate = webViewUIDelegate

        return (webView, webViewNavigationDelegate, webViewUIDelegate)
    }

    internal func loadBaseURL() {
        let request = URLRequest(
            url: configuration.appURL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 5
        )

        let navigation = webView.load(request)
        webViewNavigationDelegate.initialNavigation = navigation
    }
}
