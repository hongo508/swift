//
//  ContentView.swift
//  WebViewSampleForSwiftUI
//
//  Created by 本郷匠 on 2020/01/22.
//  Copyright © 2020 t.hongo. All rights reserved.
//

import SwiftUI
import WebKit

struct ContentView: View {
    let webView = WebKitView(view: nil, str: "https://www.google.com")
    @State var textLabel: String = ""
    
    var body: some View {
        VStack {
            TextField("検索", text: $textLabel, onEditingChanged: { begin in
                if begin {
                    print("テキスト入力中")
                }
            }, onCommit: {
                self.webView.search(str: self.textLabel)
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            webView
            
            HStack {
                Button(action: webView.back, label: {
                    Text("戻る")
                        .bold()
                })
                    .padding(.horizontal, 25)
                    .padding(.vertical, 7)
                
                Button(action: webView.forward, label: {
                    Text("進む")
                        .bold()
                })
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                
                Button(action: webView.refresh, label: {
                    Text("リロード")
                        .bold()
                })
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                
                Spacer()
            }
        }
    }
}

struct WebKitView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    var webView: WKWebView?
    let loadStr: String
    
    init(view: WKWebView?, str: String) {
        webView = WKWebView()
        loadStr = str
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView!
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let url = URL(string: loadStr)
        let request = URLRequest(url: url!)
        uiView.allowsBackForwardNavigationGestures = true
        uiView.allowsLinkPreview = true
        uiView.load(request)
    }
    
    func back() {
        if webView?.canGoBack == true {
            webView?.goBack()
        }
    }
    
    func forward() {
        if webView?.canGoForward == true {
            webView?.goForward()
        }
    }
    
    func refresh() {
        let url = URL(string: "https://www.google.com")
        let request = URLRequest(url: url!)
        webView?.load(request)
    }
    
    func search(str: String) {
        let searchStr = "https://www.google.com/?q=\(str)"
        let encStr = searchStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encStr!)
        let request = URLRequest(url: url!)
        webView?.load(request)
    }
}

class WebNavigationDelegate: UIViewController, WKNavigationDelegate {
    
    // MARK: - 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("リクエスト前")
        
        /*
         * WebView内の特定のリンクをタップした時の処理などが書ける(2019/11/16追記)
         */
        let url = navigationAction.request.url
        print("読み込もうとしているページのURLが取得できる: ", url ?? "")
        // リンクをタップしてページを読み込む前に呼ばれるので、例えば、urlをチェックして
        // ①AppStoreのリンクだったらストアに飛ばす
        // ②Deeplinkだったらアプリに戻る
        // みたいなことができる
        
        /*  これを設定しないとアプリがクラッシュする
         *  .allow  : 読み込み許可
         *  .cancel : 読み込みキャンセル
         */
        decisionHandler(.allow)
    }
    
    // MARK: - 読み込み準備開始
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("読み込み準備開始")
    }
    
    // MARK: - 読み込み設定（レスポンス取得後）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("レスポンス取得後")
        
        /*  これを設定しないとアプリがクラッシュする
         *  .allow  : 読み込み許可
         *  .cancel : 読み込みキャンセル
         */
        decisionHandler(.allow)
        // 注意：受け取るレスポンスはページを読み込みタイミングのみで、Webページでの操作後の値などは受け取れない
    }
    
    // MARK: - 読み込み開始
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("読み込み開始")
    }
    
    // MARK: - ユーザ認証（このメソッドを呼ばないと認証してくれない）
    func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("ユーザ認証")
        completionHandler(.useCredential, nil)
    }
    
    // MARK: - 読み込み完了
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("読み込み完了")
    }
    
    // MARK: - 読み込み失敗検知
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        print("読み込み失敗検知")
    }
    
    // MARK: - 読み込み失敗
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
        print("読み込み失敗")
    }
    
    // MARK: - リダイレクト
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation:WKNavigation!) {
        print("リダイレクト")
    }
}

class WebUIDelegate: UIViewController, WKUIDelegate {
    
    // alertを表示する
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "title",
                                                message: "message",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            completionHandler()
        }
        
        alertController.addAction(okAction)
        
        present(alertController ,animated: true ,completion: nil)
    }
    
    // confirm dialogを表示する
    func webView(_ webView: WKWebView,
                 runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "title",
                                                message: "message",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            completionHandler(true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController ,animated: true ,completion: nil)
    }
    
    // 入力フォーム(prompt)を表示する
    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "title",
                                                message: prompt,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler("")
        }
        
        let okHandler = { () -> Void in
            if let textField = alertController.textFields?.first {
                completionHandler(textField.text)
            } else {
                completionHandler("")
            }
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            okHandler()
        }
        
        alertController.addTextField() { $0.text = defaultText }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController ,animated: true ,completion: nil)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
