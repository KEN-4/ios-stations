//
//  FirstViewController.swift
//  ios-stations
//

import UIKit
import KeychainAccess

class FirstViewController: UIViewController {
    
    // 書籍データを保持する配列
    var books: [Book]?
    
    // API通信を行うためのクライアント
    let apiClient: BookAPIClientProtocol = BookAPIClient()
    
    // TableViewとボタンのアウトレット（UI部品との接続）
    @IBOutlet weak var tableView: UITableView!
    fileprivate let refreshCtl = UIRefreshControl()
    @IBOutlet weak var fetchBooksButton: UIButton!
    @IBOutlet weak var tapUserInfromation: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    // ボタンをタップしたときに呼ばれるアクション
    @IBAction func touchFetchBooksButton(_ sender: Any) {
        fetchBooks()
        print("Touched!")
    }
    
    @IBAction func userInformationTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showUserInformationViewController", sender: nil)
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let keychain = Keychain(service: "jp.co.techbowl.ios-stations-user")
        do {
            // トークンをKeychainから削除
            try keychain.remove("token")
            print("ログアウト成功")
            // ログアウト後の処理
            performSegue(withIdentifier: "showInitialViewController", sender: nil)
        } catch let error {
            print("ログアウト失敗: \(error)")
        }
    }
    
    // ビューがロードされたときに呼ばれるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBooks()
        
        // TableViewにリフレッシュコントロールを追加
        tableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(fetchBooks), for: .valueChanged)
        
    }
    
    // 書籍データを取得するメソッド
    @objc private func fetchBooks() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        apiClient.fetchBooks(offset: 0) { [weak self] books in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview() // アニメーション停止後にインジケータをビューから削除
                guard let books = books else { return }
                print("Fetched Books")
                self?.books = books
                self?.tableView.reloadData()
                self?.refreshCtl.endRefreshing()
            }
        }
    }
    
    // Segueの準備を行うメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SecondViewController" {
            if let secondVC = segue.destination as? SecondViewController,
               let indexPath = tableView.indexPathForSelectedRow,
               let book = books?[indexPath.row] {
                secondVC.url = book.url
            }
        }
    }
    
    // ビューが表示される直前の動作を定義
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

// UITableViewDataSourceプロトコルに適合するための拡張
extension FirstViewController: UITableViewDataSource {
    // TableViewのセルの数を決定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 0
    }
    
    // 各セルの内容を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as? BookCell,
              let book = books?[indexPath.row] else {
            return UITableViewCell()
        }
        // セルの設定
        cell.configure(with: book)
        return cell
    }
}

// UITableViewDelegateプロトコルに適合するための拡張
extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SecondViewController", sender: self)
    }
}
