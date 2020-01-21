//
//  ContentView.swift
//  WebView
//
//  Created by 本郷匠 on 2020/01/20.
//  Copyright © 2020 t.hongo. All rights reserved.
//

import SwiftUI
import WebKit

var loadLabel: String = "https://www.google.com/"

struct ContentView: View {
    @State var textLabel: String = ""
    let textFieldDelegate = TextFieldDelegate()
    
    var body: some View {
        VStack {
            TextField("検索", text: $textLabel, onEditingChanged: { begin in
                if begin {
                    
                }
            }, onCommit: {
                loadLabel = self.textLabel
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            WebView(loadStr: loadLabel)
        }
    }
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    var loadStr: String
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let url = URL(string: loadStr)
        let request = URLRequest(url: url!)
        uiView.load(request)
    }
}

class WebViewDelegate: NSObject, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView
    
    override init() {
        webView = WKWebView()
        super.init()
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
}

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var textField: UITextField
    
    override init() {
        textField = UITextField()
        super.init()
        textField.delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.becomeFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
