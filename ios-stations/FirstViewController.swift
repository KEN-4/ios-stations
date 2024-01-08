//
//  FirstViewController.swift
//  ios-stations
//

import UIKit
        
class FirstViewController: UIViewController {

    var books: [Book]?
    let apiClient: BookAPIClientProtocol = BookAPIClient()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBooks()
        
    }
    
    private func fetchBooks() {
        apiClient.fetchBooks(offset: 0) { [weak self] books in
            guard let books = books else { return }
            self?.books = books
            self?.tableView.reloadData()
        }
    }
    
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as? BookCell,
        let book = books?[indexPath.row] else {
            return UITableViewCell()
        }
        // セルの設定
        cell.configure(with: book)
        return cell
    }
}

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択された書籍の取得
        guard let book = books?[indexPath.row] else { return }
        
        guard let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else { return }

        secondVC.url = book.url

        navigationController?.pushViewController(secondVC, animated: true)
    }
}


