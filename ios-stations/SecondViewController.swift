//
//  SecondViewController.swift
//  ios-stations
//

import UIKit
import WebKit

class SecondViewController: UIViewController {

    private var webView: WKWebView!
    private var activityIndicatorView: UIActivityIndicatorView!
    var url: String!

    // NSCoderを使った初期化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // ビューがロードされた後に呼び出されるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WKWebViewを作成し、ビューコントローラのビューとして設定
        webView = WKWebView(frame: view.bounds, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = self // navigationDelegateを設定
        view.addSubview(webView) // webViewをviewに追加
        
        // アクティビティインジケータを設定
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        
        // Webページの読み込みを開始
        load(withURL: url)
    }
    
    // 指定されたURLのWebページを読み込むメソッド
    private func load(withURL urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        webView.load(request)
    }
}

// WKNavigationDelegateメソッド
extension SecondViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
}
