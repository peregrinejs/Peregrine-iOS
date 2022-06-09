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

public final class WebFrameRepresentable: UIViewRepresentable {
    public typealias UIViewType = WKWebView

    internal weak var frame: WebFrame?

    private var _frame: WebFrame {
        guard let frame = frame else {
            fatalError("WebFrameRepresentable lost reference to WebFrame.")
        }

        return frame
    }

    public final func makeUIView(context _: Context) -> WKWebView {
        let webView = _frame.webView
        _frame.loadBaseURL()
        return webView
    }

    public final func updateUIView(_: WKWebView, context _: Context) {}
}
