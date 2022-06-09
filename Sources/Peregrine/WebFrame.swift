// Peregrine for iOS: native container for hybrid apps
// Copyright (C) 2022 Caracal LLC
//
// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License version 3 as published
// by the Free Software Foundation.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License version 3
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import WebKit

public final class WebFrame: Frame {
    public let view = WebFrameRepresentable()

    internal let configuration: Configuration
    internal let appServer: FileServer?
    internal let rpcServer: RPCServer

    internal var webView: WKWebView {
        if let webView = _webView {
            return webView
        }

        let (webView, _) = load()

        return webView
    }

    internal var webViewNavigationDelegate: WebFrameNavigationDelegate {
        if let webViewNavigationDelegate = _webViewNavigationDelegate {
            return webViewNavigationDelegate
        }

        let (_, webViewNavigationDelegate) = load()

        return webViewNavigationDelegate
    }

    private var _webView: WKWebView?
    private var _webViewNavigationDelegate: WebFrameNavigationDelegate?

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
            remoteInterface: configuration.remoteInterface,
            pathHandlers: configuration.pathHandlers
        )

        rpcServer = RPCServer(configuration: rpcServerConfiguration)
        view.frame = self
    }

    /// Load the WebView and prepare for display.
    ///
    /// The WebView is lazy-loaded when either the `webView` or
    /// `webViewNavigationDelegate` properties is accessed. Usually, this
    /// happens during the lifecycles of `WebFrameRepresentable`. This avoids
    /// prematurely allocating resources and works around this bug:
    /// https://developer.apple.com/forums/thread/61432?answerId=174794022#174794022
    ///
    /// - Returns: An initialized Web View and its navigation delegate.
    private func load() -> (WKWebView, WebFrameNavigationDelegate) {
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

        let webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        let webViewNavigationDelegate = WebFrameNavigationDelegate()

        webView.allowsLinkPreview = false
        webView.navigationDelegate = webViewNavigationDelegate
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        webViewNavigationDelegate.frame = self

        _webView = webView
        _webViewNavigationDelegate = webViewNavigationDelegate

        return (webView, webViewNavigationDelegate)
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
