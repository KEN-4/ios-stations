//
//  LoginViewController.swift
//  ios-stations
//
//  Created by 内藤広貴 on 2024/01/15.
//

import UIKit
import Alamofire
import KeychainAccess

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var uiLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
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
        emailTextField.delegate = self
        passwordTextField.delegate = self
        updateLoginButtonState()
    }
    
    //textFieldにテキストが入力されたり変更されたりするときに呼ばれるdelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // ボタンの状態を更新
        updateLoginButtonState()
        return true
    }
    
    func updateLoginButtonState() {
        // 全てのTextFieldに入力があるか確認
        // textがnillの場合,trueを返す→!で反転するからfalseを返す
        let isEmailEntered = !(emailTextField.text?.isEmpty ?? true)
        let isPasswordEntered = !(passwordTextField.text?.isEmpty ?? true)
        // ボタンの有効/無効を切り替え
        loginButton.isEnabled = isEmailEntered && isPasswordEntered
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("tapped")
        guard let email = emailTextField.text, !email.isEmpty, email.isEmail() else {
            self.uiLabel.text = "無効なメールアドレス形式です"
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty, password.isPassword() else {
            self.uiLabel.text = "パスワードの形式が不正です"
            return
        }
        // ログイン処理の実行
        loginUser(email: email, password: password)
    }
    
    func loginUser(email: String, password: String) {
        let loginURL = "https://railway.bookreview.techtrain.dev/signin" 
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        
        struct LoginResponse: Decodable {
            let token: String
        }
        
        AF.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let loginResponse):
                print("レスポンスデータ: \(loginResponse)")
                let keychain = Keychain(service: "jp.co.techbowl.ios-stations-user")
                keychain[TokenKey.token] = loginResponse.token
                print("ログイン成功: Token = \(loginResponse.token)")
                DispatchQueue.main.async {
                    self.uiLabel.text = "ログイン成功"
                    self.performSegue(withIdentifier: "showFirstViewControllerFromLogin", sender: nil)
                }
            case .failure(let error):
                print("ログイン失敗: \(error)")
                DispatchQueue.main.async {
                    self.uiLabel.text = "ログイン失敗"
                }
            }
        }
    }
}
