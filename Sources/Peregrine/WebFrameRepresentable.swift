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
