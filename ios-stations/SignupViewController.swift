//
//  SignupViewController.swift
//  ios-stations
//
//  Created by 内藤広貴 on 2024/01/15.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var uiLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        signUpButton.isEnabled = false
//        emailTextField.delegate = self
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

extension String {
    func isEmail() -> Bool {
        let pattern = "^[\\w\\.\\-_]+@[\\w\\.\\-_]+\\.[a-zA-Z]+$"
        let matches = validate(str: self, pattern: pattern)
        return matches.count > 0
    }
    
    func isPassword() -> Bool {
        let pattern = "^(?=.*?[^\\w])(?=.*?[\\d]$"
        let matches = validate(str: self, pattern: pattern)
        return matches.count > 0
    }
    
    private func validate(str: String, pattern: String) -> [NSTextCheckingResult] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        return regex.matches(in: str, range: NSRange(location: 0, length: str.count))
    }
}
