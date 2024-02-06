//
//  Book.swift
//  ios-stations
//

struct Book: Decodable {
    let id: String
    let title: String
    let url: String
    let detail: String
    let review: String
    let reviewer: String
    let isMine: Bool?
}
