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
    
    // インジケータ
    private var activityIndicator: UIActivityIndicatorView!
    
    // TableViewとボタンのアウトレット（UI部品との接続）
    @IBOutlet weak var tableView: UITableView!
    fileprivate let refreshCtl = UIRefreshControl()
    @IBOutlet weak var fetchBooksButton: UIButton!
    @IBOutlet weak var tapUserInfromation: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var submissionButton: UIButton!
    
    // ボタンをタップしたときに呼ばれるアクション
    @IBAction func touchFetchBooksButton(_ sender: Any) {
        fetchBooks()
        print("Touched!")
    }
    
    @IBAction func userInformationTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showUserInformationViewController", sender: nil)
    }

    @IBAction func submissonButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showReviewSubmissionViewController", sender: nil)
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
        if Network.shared.isOnline() {
            // オンライン時の処理
        } else {
            // オフライン時の処理
            let alert = UIAlertController(title: "オフラインです", message: "インターネット接続が必要です。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        // アクティビティインジケータの設定
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        // 初期状態では非表示にしておく
        activityIndicator.isHidden = true
        // TableViewにリフレッシュコントロールを追加
        tableView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(fetchBooks), for: .valueChanged)
        
    }
    
    // 書籍データを取得するメソッド
    @objc private func fetchBooks() {
        // インジケータを表示
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        apiClient.fetchBooks(offset: 0) { [weak self] books in
            DispatchQueue.main.async {
                // インジケータを非表示
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
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
        if segue.identifier == "showReviewDetailViewController" {
            if let reviewDetailVC = segue.destination as? ReviewDetailViewController,
               let book = sender as? Book {
                reviewDetailVC.bookId = book.id
                reviewDetailVC.bookTitle = book.title
                reviewDetailVC.bookURL = book.url
                reviewDetailVC.bookDetail = book.detail
                reviewDetailVC.bookReview = book.review
            }
        } else if segue.identifier == "showReviewEditViewController" {
            if let editVC = segue.destination as? ReviewEditViewController,
               let book = sender as? Book {
                editVC.bookId = book.id
                editVC.bookTitle = book.title
                editVC.bookURL = book.url
                editVC.bookDetail = book.detail
                editVC.bookReview = book.review
            }
        }
    }
    
    // ビューが表示される直前の動作を定義
    override func viewWillAppear(_ animated: Bool) {
        fetchBooks()
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
        guard let book = books?[indexPath.row] else { return }
        
        // レビューを自分が投稿したか
        if book.isMine == true {
            // isMineがtrueの場合，編集画面へ
            performSegue(withIdentifier: "showReviewEditViewController", sender: book)
        } else {
            // isMineがfalse場合、書籍レビュー詳細画面へ
            performSegue(withIdentifier: "showReviewDetailViewController", sender: book)
        }
    }
}
