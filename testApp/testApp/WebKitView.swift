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
    let webViewDelegate = WebViewDelegate()
    
    var body: some View {
        VStack {
            WebView(url: "https://www.google.com/")
        }
    }
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: URL(string: url)!)
        uiView.load(request)
    }
    
    func back(uiView: WKWebView) {
        uiView.goBack()
    }
    
    func forward(uiView: WKWebView) {
        uiView.goForward()
    }
}

class WebViewDelegate: NSObject, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView!
    
    override init() {
        webView = WKWebView()
        super.init()
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        WKWebView(frame: .zero)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("bbb")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("ccc")
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
