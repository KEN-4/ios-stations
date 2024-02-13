import UIKit
import Alamofire
import KeychainAccess

class ReviewDetailViewController: UIViewController, UITextFieldDelegate {
    
    var bookId: String?
    var bookTitle: String?
    var bookURL: String?
    var bookDetail: String?
    var bookReview: String?
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var jumpUrlButton: UIButton!
    
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
        
        // テキストフィールドに渡された情報を設定
        titleLabel.text = bookTitle
        detailLabel.text = bookDetail
        reviewLabel.text = bookReview
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailUrlViewController" {
            if let secondVC = segue.destination as? DetailUrlViewController {
                secondVC.url = self.bookURL // ここでURLを渡します
            }
        }
    }
}
