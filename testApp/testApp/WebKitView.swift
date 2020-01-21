//
//  WebKitView.swift
//  testApp
//
//  Created by 本郷匠 on 2020/01/18.
//  Copyright © 2020 t.hongo. All rights reserved.
//

import SwiftUI
import WebKit

@available(iOS 13.0, *)
struct WebKitView: View {
    var body: some View {
        VStack {
            WebView(url: "https://www.google.com")
        }
    }
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let url: String
    let webViewDelegate = WebViewDelegate()
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: URL(string: url)!)
        uiView.load(request)
    }
}

class WebViewDelegate: NSObject, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    var webView: WKWebView!
    
    let configuration = WKWebViewConfiguration()
    let controller = WKUserContentController()
    
    override init() {
        super.init()
        controller.add(self, name: "callbackHandler")
        configuration.userContentController = controller
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            print("javascript: \(message.body)")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let execJs: String = "cosole.log(\"hello,world\")"
        webView.evaluateJavaScript(execJs, completionHandler: {
            (success, error) in
        })
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let cred = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct WebKitView_Previews: PreviewProvider {
    static var previews: some View {
        WebKitView()
    }
}
#endif
