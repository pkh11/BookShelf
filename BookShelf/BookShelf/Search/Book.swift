//
//  Book.swift
//  BookShelf
//
//  Created by 박균호 on 2021/03/11.
//

import Foundation

struct Keyword: Hashable {
    var query: String
}

struct Searh: Codable {
    var total: String
    var page: String
    var books: [Book]
}

struct Book: Codable {
    var title: String
    var subtitle: String
    var isbn13: String
    var price: String
    var image: String
    var url: String
}

struct Detail: Codable {
    var error: String
    var title: String
    var subtitle: String
    var isbn13: String
    var price: String
    var image: String
    var url: String
    var authors: String
    var publisher: String
    var isbn10: String
    var pages: String
    var year: String
    var rating: String
    var desc: String
    var pdf: String?
}
