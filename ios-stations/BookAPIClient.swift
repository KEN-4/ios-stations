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
        AF.request(url).response { response in
            print("Received data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "Invalid data")")

            guard response.error == nil else {
                print("Error: \(response.error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = response.data, let httpResponse = response.response, httpResponse.statusCode == 200 else {
                print("Error: Invalid response or status code.")
                completion(nil)
                return
            }
            
            do {
                let books = try JSONDecoder().decode([Book].self, from: data)
                completion(books)
            } catch {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
