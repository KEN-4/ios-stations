
import UIKit
import Alamofire
import KeychainAccess

class UserInformationViewController: UIViewController {
    
    @IBOutlet weak var currentUserNameTextField: UITextField!
    @IBOutlet weak var newUserNameTextField: UITextField!
    @IBOutlet weak var changeUserInformationButton: UIButton!
    @IBOutlet weak var uiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserProfile()
        
    }
    
    @IBAction func changeUserInformationButtonTapped(_ sender: Any) {
        // 新しいユーザー名をテキストフィールドから取得
        guard let newUsername = newUserNameTextField.text, !newUsername.isEmpty else {
            print("新しいユーザー名が入力されていません")
            return
        }
        
        updateUserProfile(newUsername: newUsername)
    }
    
    // ユーザー情報を取得する関数
    // この関数には引数は必要ありません
    func fetchUserProfile() {
        let keychain = Keychain(service: "jp.co.techbowl.ios-stations-user")
        guard let token = keychain["token"] else {
            print("認証トークンがありません")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        struct UserProfile: Decodable {
            let name: String
        }
        
        AF.request("https://railway.bookreview.techtrain.dev/users", method: .get, headers: headers).responseDecodable(of: UserProfile.self) { response in
            switch response.result {
            case .success(let userProfile):
                self.currentUserNameTextField.text = userProfile.name
                print("ユーザー名: \(userProfile.name)")
            case .failure(let error):
                print("エラー: \(error)")
            }
        }
    }
    
    // ユーザー名を更新する関数
    func updateUserProfile(newUsername: String) {
        let keychain = Keychain(service: "jp.co.techbowl.ios-stations-user")
        guard let token = keychain["token"] else {
            print("認証トークンがありません")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let parameters: Parameters = [
            "name": newUsername
        ]
        
        AF.request("https://railway.bookreview.techtrain.dev/users", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("ユーザ情報の更新に成功しました")
                self.currentUserNameTextField.text = newUsername
            case .failure(let error):
                print("更新に失敗しました: \(error)")
            }
        }
    }
}
