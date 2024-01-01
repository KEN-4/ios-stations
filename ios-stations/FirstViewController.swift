//
//  FirstViewController.swift
//  ios-stations
//

import UIKit
        
class FirstViewController: UIViewController {

    var books: [Book]?
    
    // ボタンのUIと紐付け
    @IBOutlet weak var presentSecondViewController: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // self.view.backgroundColor = UIColor.Theme.main
    }
    // ボタンを押した時の処理
    @IBAction func presentSecondViewController(_ sender: UIButton) {
        let secondViewController = SecondViewController(url: "https://techbowl.co.jp/")
        secondViewController.modalPresentationStyle = .fullScreen
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    //    @IBAction func tappedButton(_ sender: UIButton) {
//        tapButton.backgroundColor = UIColor.random
//    }
    
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

