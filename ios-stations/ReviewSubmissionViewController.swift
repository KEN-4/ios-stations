import UIKit
import Alamofire
import KeychainAccess

class ReviewSubmissionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var uiLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        urlTextField.delegate = self
        detailTextField.delegate = self
        reviewTextField.delegate = self
        
        updateSubmitButtonState()
    }
    
    //textFieldにテキストが入力されたり変更されたりするときに呼ばれるdelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // ボタンの状態を更新
        updateSubmitButtonState()
        return true
    }
    
    func updateSubmitButtonState() {
        // 全てのTextFieldに入力があるか確認
        // textがnillの場合,trueを返す→!で反転するからfalseを返す
        let isTitleEntered = !(titleTextField.text?.isEmpty ?? true)
        let isUrlEntered = !(urlTextField.text?.isEmpty ?? true)
        let isDetailEntered = !(detailTextField.text?.isEmpty ?? true)
        let isReviewEntered = !(reviewTextField.text?.isEmpty ?? true)
        // ボタンの有効/無効を切り替え
        submitButton.isEnabled = isTitleEntered && isUrlEntered && isDetailEntered && isReviewEntered
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let name = titleTextField.text, name.isTitle() else {
            self.uiLabel.text = "タイトルは3文字以上で入力してください"
            return
        }
        guard let name = urlTextField.text, name.isURL() else {
            self.uiLabel.text = "URLは3文字以上で入力してください"
            return
        }
        guard let name = detailTextField.text, name.isDetail() else {
            self.uiLabel.text = "詳細情報は3文字以上で入力してください"
            return
        }
        guard let name = reviewTextField.text, name.isReview() else {
            self.uiLabel.text = "レビューは3文字以上で入力してください"
            return
        }
        submitReview()
    }
    
    private func submitReview() {
        let keychain = Keychain(service: "jp.co.techbowl.ios-stations-user")
        guard let token = keychain[TokenKey.token] else {
            print("認証トークンがありません")
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let parameters: Parameters = [
            "title": titleTextField.text!,
            "url": urlTextField.text!,
            "detail": detailTextField.text!,
            "review": reviewTextField.text!
        ]
        
        AF.request("https://railway.bookreview.techtrain.dev/books", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("レビュー投稿に成功しました")
                DispatchQueue.main.async {
                    self.uiLabel.text = "レビュー投稿に成功しました"
                }
            case .failure(let error):
                print("レビュー投稿に失敗しました: \(error)")
                DispatchQueue.main.async {
                    self.uiLabel.text = "レビュー投稿に失敗しました"
                }
            }
        }
    }
}
