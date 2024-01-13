//
//  SecondViewController.swift
//  ios-stations
//

import UIKit
import WebKit

class SecondViewController: UIViewController {

    private var webView: WKWebView!
    var url: String!
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    // NSCoderを使った初期化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // ビューがロードされた後に呼び出されるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WKWebViewを作成し、ビューコントローラのビューとして設定
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        view = webView
        
        // Webページの読み込みを開始
        load(withURL: url)
    }
    
    // 指定されたURLのWebページを読み込むメソッド
    private func load(withURL urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
}
