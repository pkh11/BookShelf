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
    
    func fetchDetailOfBook() {
        
    }
}

struct Keyword: Hashable {
    var query: String
}

class Searh: Codable {
    var total: String
    var page: String
    var books: [Book]
}

class Book: Codable {
    var title: String
    var subtitle: String
    var isbn13: String
    var price: String
    var image: String
    var url: String
    
    init(_ title: String, _ subtitle: String, _ isbn13: String, _ price: String, _ image: String, _ url: String) {
        self.title = title
        self.subtitle = subtitle
        self.isbn13 = isbn13
        self.price = price
        self.image = image
        self.url = url
    }
}

class Detail: Book {
    var authors: String
    var publisher: String
    var isbn10: String
    var pages: String
    var year: String
    var rating: String
    var desc: String
    var pdf: String
    
   
    init(_ authors: String, _ publisher: String,
         _ isbn10: String, _ pages: String,
         _ year: String, _ rating: String,
         _ desc: String, _ pdf: String,
         _ title: String, _ subtitle: String,
         _ isbn13: String, _ price: String,
         _ image: String, _ url: String) {

        self.authors = authors
        self.publisher = publisher
        self.isbn10 = isbn10
        self.pages = pages
        self.year = year
        self.rating = rating
        self.desc = desc
        self.pdf = pdf
        super.init(title, subtitle, isbn13, price, image, url)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}

