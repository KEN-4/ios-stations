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
        let url = "https://railway.bookreview.tech/books"
        AF.request(url).response { response in
            guard let data = response.data else {
                completion(nil)
                return
            }
            
            do {
                let books = try JSONDecoder().decode([Book].self, from: data)
                completion(books)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
