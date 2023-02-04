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
