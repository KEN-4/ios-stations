//
//  BookAPIClient.swift
//  ios-stations
//
import Alamofire
import Foundation
import KeychainAccess

protocol BookAPIClientProtocol {
    func fetchBooks(offset: Int, completion: @escaping ([Book]?) -> Void)
}

class BookAPIClient: BookAPIClientProtocol {
    func fetchBooks(offset: Int, completion: @escaping ([Book]?) -> Void) {
        let url = "https://railway.bookreview.techtrain.dev/books"
        let keychain = Keychain(service: "jp.co.techbowl.ios-stations-user")
        guard let token = keychain[TokenKey.token] else {
            print("認証トークンがありません")
            completion(nil)
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, headers: headers).response { response in
            guard let data = response.data, !data.isEmpty else {
                print("データが取得できませんでした。エラー: \(String(describing: response.error))")
                completion(nil)
                return
            }
            
            // レスポンスデータの内容をログに出力
            if let json = String(data: data, encoding: .utf8) {
                print("Received JSON: \(json)")
            }
            
            do {
                let books = try JSONDecoder().decode([Book].self, from: data)
                completion(books)
            } catch {
                print("デコード中にエラーが発生しました: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
