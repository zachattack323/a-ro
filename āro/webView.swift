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
//    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

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

        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 12_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15"

    }
    
    func loadUrl() {
        if urlString.starts(with: "https://"){
            guard let url = URL(string: urlString) else {
                return
            }
            
            webView.load(URLRequest(url: url))
        } else if urlString.contains(" "){
            let newString = urlString.replacingOccurrences(of: " ", with: "+")

            urlString = "https://www.google.com/search?q=" + newString
            guard let url = URL(string: urlString) else {
                return
            }
            
            webView.load(URLRequest(url: url))
        } else if urlString.isValidURL {
            let newString = "https://" + urlString
            guard let url = URL(string: newString) else {
                return
            }
            
            webView.load(URLRequest(url: url))
        } else {
            let newString = urlString.replacingOccurrences(of: " ", with: "+")

            urlString = "https://www.google.com/search?q=" + newString
            guard let url = URL(string: urlString) else {
                return
            }
            webView.load(URLRequest(url: url))

        }
        
        /*
        guard let url = URL(string: urlString) else {
            return
        }
        
        webView.load(URLRequest(url: url))
         */
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

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
