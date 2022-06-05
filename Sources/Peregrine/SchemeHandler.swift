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

internal struct SchemeHandlerServerResponseHandler: ServerResponseHandler {
    internal let task: WKURLSchemeTask

    func didReceive(response: URLResponse) {
        task.didReceive(response)
    }

    func didReceive(bytes: Data) {
        task.didReceive(bytes)
    }

    func didFinish() {
        task.didFinish()
    }
}

internal class SchemeHandler<T: ServerProtocol>: NSObject, WKURLSchemeHandler {
    internal let server: T
    internal let queue: DispatchQueue

    internal init(server: T, queue: DispatchQueue) {
        self.server = server
        self.queue = queue
    }

    internal func webView(_: WKWebView, start task: WKURLSchemeTask) {
        queue.async {
            let request = task.request
            let handler = SchemeHandlerServerResponseHandler(task: task)

            self.server.respond(to: request, usingHandler: handler)
        }
    }

    internal func webView(_: WKWebView, stop task: WKURLSchemeTask) {
        queue.async {
            let request = task.request
            self.server.stopResponding(to: request)
        }
    }
}

internal final class AppSchemeHandler: SchemeHandler<FileServer> {}

internal final class RPCSchemeHandler: SchemeHandler<RPCServer> {}
