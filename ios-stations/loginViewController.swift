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
        
        // Alamofireを使用したAPIリクエスト
        AF.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                // JSONをDictionaryにキャスト
                if let dictionary = value as? [String: Any],
                   // トークンを取得
                   let token = dictionary["token"] as? String {
                    let keychain = Keychain(service: "jp.co.techbowl.ios-stations-user")
                    // トークンをKeychainに保存
                    keychain["token"] = token
                    print("ログイン成功")
                    DispatchQueue.main.async {
                        // ログイン成功時のUI更新処理
                        self.uiLabel.text = "ログイン成功"
                    }
                }
            case .failure:
                print("ログイン失敗")
                DispatchQueue.main.async {
                    self.uiLabel.text = "ログイン失敗"
                }
            }
        }
    }
}
