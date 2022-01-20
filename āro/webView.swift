//
//  webView.swift
//  āro
//
//  Created by Zachary Hixon on 1/20/22.
//

import Foundation
import WebKit
import Cocoa
import SwiftUI
import Combine



struct WebView: NSViewRepresentable {
    typealias NSViewType = WKWebView

    let webView: WKWebView
    
    func makeNSView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) { }
}

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // TODO
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // TODO
        decisionHandler(.allow)
    }
}

class WebViewModel: ObservableObject {
    let webView: WKWebView

    
    private let navigationDelegate: WebViewNavigationDelegate
    
    init() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: .infinite, configuration: configuration)
        navigationDelegate = WebViewNavigationDelegate()

        webView.navigationDelegate = navigationDelegate
        setupBindings()
    }
    
    @Published var urlMain: URL = URL(string: "https://google.com")!
    @Published var urlString: String = ""

    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var isLoading: Bool = false
    
    private func setupBindings() {
        webView.publisher(for: \.canGoBack)
            .assign(to: &$canGoBack)
        
        webView.publisher(for: \.canGoForward)
            .assign(to: &$canGoForward)
        
        webView.publisher(for: \.isLoading)
            .assign(to: &$isLoading)
        if webView.url == nil{
        } else {
        webView.publisher(for: \.url!)
            .assign(to: &$urlMain)
        }
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36"

    }
    
    func loadUrl() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    func goForward() {
        webView.goForward()
    }
    
    func goBack() {
        webView.goBack()
    }
    func getURL() -> URL {
        return webView.url!
    }
    
}

