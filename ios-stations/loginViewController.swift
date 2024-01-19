//
//  LoginViewController.swift
//  ios-stations
//
//  Created by 内藤広貴 on 2024/01/15.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var uiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
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
            case .success:
                print("ログイン成功")
                DispatchQueue.main.async {
                    // ログイン成功時のUI更新処理
                    self.uiLabel.text = "ログイン成功"
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
