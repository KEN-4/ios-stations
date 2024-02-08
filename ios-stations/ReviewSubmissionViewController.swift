import UIKit
import Alamofire
import KeychainAccess

class ReviewSubmissionViewController: UIViewController {
    @IBOutlet weak var uiLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!

    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        // バリデーション
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
