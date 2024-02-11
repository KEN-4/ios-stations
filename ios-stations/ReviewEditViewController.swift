import UIKit
import Alamofire
import KeychainAccess

class ReviewEditViewController: UIViewController, UITextFieldDelegate {
    
    var bookId: String?
    var bookTitle: String?
    var bookURL: String?
    var bookDetail: String?
    var bookReview: String?
    
    @IBOutlet weak var uiLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
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
        titleTextField.delegate = self
        urlTextField.delegate = self
        detailTextField.delegate = self
        reviewTextField.delegate = self
        
        // テキストフィールドに渡された情報を設定
        titleTextField.text = bookTitle
        urlTextField.text = bookURL
        detailTextField.text = bookDetail
        reviewTextField.text = bookReview
        
        updateEditButtonState()
    }
    
    //textFieldにテキストが入力されたり変更されたりするときに呼ばれるdelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // ボタンの状態を更新
        updateEditButtonState()
        return true
    }
    
    func updateEditButtonState() {
        // 全てのTextFieldに入力があるか確認
        // textがnillの場合,trueを返す→!で反転するからfalseを返す
        let isTitleEntered = !(titleTextField.text?.isEmpty ?? true)
        let isUrlEntered = !(urlTextField.text?.isEmpty ?? true)
        let isDetailEntered = !(detailTextField.text?.isEmpty ?? true)
        let isReviewEntered = !(reviewTextField.text?.isEmpty ?? true)
        // ボタンの有効/無効を切り替え
        editButton.isEnabled = isTitleEntered && isUrlEntered && isDetailEntered && isReviewEntered
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, title.isTitle() else {
            self.uiLabel.text = "タイトルは3文字以上で入力してください"
            return
        }
        guard let url = urlTextField.text, url.isURL() else {
            self.uiLabel.text = "有効なURLを入力してください"
            return
        }
        guard let detail = detailTextField.text, detail.isDetail() else {
            self.uiLabel.text = "詳細情報は3文字以上で入力してください"
            return
        }
        guard let review = reviewTextField.text, review.isReview() else {
            self.uiLabel.text = "レビューは3文字以上で入力してください"
            return
        }
        editReview(title: title, url: url, detail: detail, review: review)
    }
    
    private func editReview(title: String, url: String, detail: String, review: String) {
        let keychain = Keychain(service: "jp.co.techbowl.ios-stations-user")
        guard let bookId = self.bookId else {
            print("bookIdがありません")
            return
        }
        guard let token = keychain[TokenKey.token] else {
            print("認証トークンがありません")
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let parameters: Parameters = [
            "title": title,
            "url": url,
            "detail": detail,
            "review": review
        ]
        
        AF.request("https://railway.bookreview.techtrain.dev/books/\(bookId)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success(_):
                print("レビュー更新に成功しました")
                DispatchQueue.main.async {
                    self.uiLabel.text = "レビュー更新に成功しました"
                }
            case .failure(let error):
                print("レビュー更新に失敗しました: \(error)")
                DispatchQueue.main.async {
                    self.uiLabel.text = "レビュー更新に失敗しました"
                }
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let keychain = Keychain(service: "jp.co.techbowl.ios-stations-user")
        guard let bookId = self.bookId else {
            print("bookIdがありません")
            return
        }
        guard let token = keychain[TokenKey.token] else {
            print("認証トークンがありません")
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let url = "https://railway.bookreview.techtrain.dev/books/\(bookId)"
        
        AF.request(url, method: .delete, headers: headers).response { response in
            switch response.result {
            case .success(_):
                print("書籍削除に成功しました")
                DispatchQueue.main.async {
                    self.uiLabel.text = "書籍削除に成功しました"
                }
            case .failure(let error):
                print("書籍削除に失敗しました: \(error)")
                DispatchQueue.main.async {
                    self.uiLabel.text = "書籍削除に失敗しました"
                }
            }
        }
    }
}
