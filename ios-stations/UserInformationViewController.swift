
import UIKit
import Alamofire
import KeychainAccess

class UserInformationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var currentUserNameTextField: UITextField!
    @IBOutlet weak var newUserNameTextField: UITextField!
    @IBOutlet weak var changeUserInformationButton: UIButton!
    @IBOutlet weak var uiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newUserNameTextField.delegate = self
        updateChangeUserInformationButtonState()
        fetchUserProfile()
        
    }
    
    // テキストフィールドにテキストが入力されるたびに呼ばれる
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateChangeUserInformationButtonState()
        return true
    }
    
    // ボタンの状態を更新するメソッド
    func updateChangeUserInformationButtonState() {
        let isNewUsernameEntered = !(newUserNameTextField.text?.isEmpty ?? true)
        changeUserInformationButton.isEnabled = isNewUsernameEntered
    }
    
    @IBAction func changeUserInformationButtonTapped(_ sender: Any) {
        // 新しいユーザー名をテキストフィールドから取得
        guard let newUsername = newUserNameTextField.text, newUsername.isName() else {
            uiLabel.text = "ユーザー名は3文字以上で入力してください"
            return
        }
        
        updateUserProfile(newUsername: newUsername)
    }
    
    // ユーザー情報を取得する関数
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
                DispatchQueue.main.async {
                    self.currentUserNameTextField.text = userProfile.name
                    print("ユーザー名: \(userProfile.name)")
                }
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
        
        struct NewUserProfile: Decodable {
            let name: String
        }
        
        AF.request("https://railway.bookreview.techtrain.dev/users", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: NewUserProfile.self) { response in
            switch response.result {
            case .success(let responseData):
                print("ユーザ情報の更新に成功しました")
                DispatchQueue.main.async {
                    self.uiLabel.text = "ユーザ情報の更新に成功しました"
                    self.fetchUserProfile()
                    // これが間違っている可能性があるため、もう一度読み込みを行う
                    // self.currentUserNameTextField.text = newUsername
                }
             case .failure(let error):
                print("更新に失敗しました: \(error)")
                DispatchQueue.main.async {
                    self.uiLabel.text = "ユーザ情報の更新に失敗しました"
                }
            }
        }
    }
}
