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
    internal static func dispatchQueue(from configuration: Configuration)
        -> DispatchQueue {
        return DispatchQueue(
            label: configuration.queueLabel,
            qos: .userInitiated
        )
    }

    internal static func appServer(from configuration: Configuration) -> FileServer? {
        guard configuration.baseURL.isFileURL else {
            return nil
        }

        let appServerConfiguration = FileServer.Configuration(
            scheme: Configuration.appScheme,
            baseURL: configuration.baseURL
        )

        return FileServer(configuration: appServerConfiguration)
    }

    internal static func rpcServer(from configuration: Configuration) -> RPCServer {
        let rpcServerConfiguration = RPCServer.Configuration(
            scheme: Configuration.rpcScheme,
            allowedOrigin: configuration.allowedOrigin,
            remoteInterface: configuration.remoteInterface,
            pathHandlers: configuration.pathHandlers
        )

        return RPCServer(configuration: rpcServerConfiguration)
    }

    public let view: WebFrameRepresentable

    internal let configuration: Configuration
    internal let appServer: FileServer?
    internal let rpcServer: RPCServer
    internal let webView: WKWebView
    internal let webViewNavigationDelegate: WebFrameNavigationDelegate

    public init(configuration: Configuration) {
        let queue = WebFrame.dispatchQueue(from: configuration)

        appServer = WebFrame.appServer(from: configuration)
        rpcServer = WebFrame.rpcServer(from: configuration)

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

        self.configuration = configuration
        self.webView = webView
        self.webViewNavigationDelegate = webViewNavigationDelegate
        view = WebFrameRepresentable()

        self.webViewNavigationDelegate.frame = self
        view.frame = self
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
