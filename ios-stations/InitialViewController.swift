//
//  InitialViewController.swift
//  ios-stations
//
//  Created by 内藤広貴 on 2024/01/23.
//

import UIKit
import KeychainAccess

class InitialViewController: UIViewController {
    
    override func viewDidLoad() {	
        super.viewDidLoad()
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        let keychain = Keychain(service: "jp.co.techbowl.ios-stations-user")
        if keychain[TokenKey.token] != nil {
            // トークンが存在する場合
            navigateToFirstViewController()
            print("exist")
        } else {
            // トークンが存在しない場合
            navigateToLoginSignupViewController()
            print("non")
        }
    }
    
    func navigateToFirstViewController() {
        performSegue(withIdentifier: "showFirstViewControllerFromInitial", sender: self)
    }
    
    func navigateToLoginSignupViewController() {
        performSegue(withIdentifier: "showViewController", sender: self)
    }
}

