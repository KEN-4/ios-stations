import UIKit
import WebKit

class DetailUrlViewController: UIViewController {

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
        if Network.shared.isOnline() {
        } else {
            // オフライン時の処理
            let alert = UIAlertController(title: "オフラインです", message: "インターネット接続が必要です。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        
        // WKWebViewを作成し、ビューコントローラのビューとして設定
        webView = WKWebView(frame: view.bounds, configuration: WKWebViewConfiguration())
        // navigationDelegateを設定
        webView.navigationDelegate = self
        // webViewをviewに追加
        view.addSubview(webView)
        
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
        webView.load(request)
    }
}

// WKNavigationDelegateメソッド
extension DetailUrlViewController: WKNavigationDelegate {
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
