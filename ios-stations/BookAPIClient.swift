//
//  BookAPIClient.swift
//  ios-stations
//
import Alamofire
import Foundation


protocol BookAPIClientProtocol {
    func fetchBooks(offset: Int, completion: @escaping ([Book]?) -> Void)
}

class BookAPIClient: BookAPIClientProtocol {
    func fetchBooks(offset: Int, completion: @escaping ([Book]?) -> Void) {
        let url = "https://railway.bookreview.techtrain.dev/public/books"
        AF.request(url).response(completionHandler: { response in
            do {
                // JSONからBookオブジェクトへのデコード
                let books = try JSONDecoder().decode([Book].self, from: response.data!)
                completion(books)
                print(books)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        })
    }
}
