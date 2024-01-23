//
//  SignupViewController.swift
//  ios-stations
//
//  Created by 内藤広貴 on 2024/01/15.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var uiLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.delegate = self
        updateSignUpButtonState()
        //        signUpButton.isEnabled = false
        //        emailTextField.delegate = self
    }
    
    //textFieldにテキストが入力されたり変更されたりするときに呼ばれるdelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // ボタンの状態を更新
        updateSignUpButtonState()
        return true
    }
    
    func updateSignUpButtonState() {
        // 全てのTextFieldに入力があるか確認
        // textがnillの場合,trueを返す→!で反転するからfalseを返す
        let isEmailEntered = !(emailTextField.text?.isEmpty ?? true)
        let isPasswordEntered = !(passwordTextField.text?.isEmpty ?? true)
        let isUserNameEntered = !(userNameTextField.text?.isEmpty ?? true)
        // ボタンの有効/無効を切り替え
        signUpButton.isEnabled = isEmailEntered && isPasswordEntered && isUserNameEntered
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        guard let name = userNameTextField.text, !name.isEmpty else {
            self.uiLabel.text = "ユーザー名を入力してください"
            return
        }
        guard let email = emailTextField.text, !email.isEmpty, email.isEmail() else {
            self.uiLabel.text = "無効なメールアドレス形式です"
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty, password.isPassword() else {
            self.uiLabel.text = "パスワードの形式が不正です"
            return
        }
        
        signupUser(name: name, email: email, password: password)
    }
    
    func signupUser(name: String, email: String, password: String) {
        let signupURL = "https://railway.bookreview.techtrain.dev/users"
        let parameters: Parameters = [
            "name": name,
            "email": email,
            "password": password
        ]

        
        AF.request(signupURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                print("サインアップ成功")
                DispatchQueue.main.async {
                    // サインアップ成功時のUI更新処理
                    self.uiLabel.text = "サインアップ成功"
                }
            case .failure:
                print("サインアップ失敗")
                DispatchQueue.main.async {
                    self.uiLabel.text = "ログイン失敗"
                }
            }
        }
    }
}
