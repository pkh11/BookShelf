//
//  SearchManager.swift
//  BookShelf
//
//  Created by 박균호 on 2021/03/05.
//

import Foundation

class SearchManager {
    
    static let sharedInstance = SearchManager()
    var keywords: [Keyword] = []
    var books: [Book] = []
    var book: Detail?
    
    let networkManager = NetworkManager.sharedInstance
    
    private init() {
        let keywordList = fetchKeywords()
        self.keywords = keywordList
    }
    
    func fetchKeywords() -> [Keyword] {
        if let keywords = UserDefaults.standard.object(forKey: "keywordList") as? [String:Date] {
            var lists = [Keyword]()
            for obj in keywords.sorted(by: { $0.1 > $1.1 }) {
                let data = Keyword(query: obj.key)
                lists.append(data)
            }
            return lists
        }
        return keywords
    }

    func keyword(at index: Int) -> Keyword? {
        return keywords[index]
    }
    
    func removeKeywords() {
        UserDefaults.standard.removeObject(forKey: "keywordList")
        keywords = []
    }
    
    func setKeyword(_ keyword: String) {
        if var recentList = UserDefaults.standard.object(forKey: "keywordList") as? [String:Date] {
            if let _ = recentList[keyword] {
                recentList.updateValue(Date(), forKey: keyword)
            } else {
                recentList[keyword] = Date()
            }
            UserDefaults.standard.set(recentList, forKey: "keywordList")
            keywords = fetchKeywords()
        } else {
            let dic: [String:Date] = [keyword:Date()]
            UserDefaults.standard.set(dic, forKey: "keywordList")
        }
    }
    
    func fetchBooks(_ query: String, completion: @escaping ([Book])->Void) {
        books = []
        networkManager.getBookList(query) { data in
            guard let data = data else { return }
            self.books = data.books
            completion(self.books)
        }
    }
    
    func fetchDetailOfBook(_ isbn: String, completion: @escaping ((Detail)->Void)) {
        networkManager.getBook(isbn) { data in
            guard let data = data else { return }
            self.book = data
            completion(data)
        }
    }
}

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

