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
    var memo: String = ""
    
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
            
        } else {
            let dic: [String:Date] = [keyword:Date()]
            UserDefaults.standard.set(dic, forKey: "keywordList")
        }
        keywords = fetchKeywords()
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
            self.memo = self.fetchMemo(isbn)
            completion(data)
        }
    }
    
    func fetchMemo(_ isbn: String) -> String {
        if let memos = UserDefaults.standard.object(forKey: "memo") as? [String:String] {
            if let memo = memos[isbn] {
                return memo
            }
        }
        return ""
    }
    
    func setMemo(_ text: String, _ isbn: String, completion: @escaping (Bool)->Void) {
        if var memos = UserDefaults.standard.object(forKey: "memo") as? [String:String] {
            if let _ = memos[isbn] {
                memos.updateValue(text, forKey: isbn)
            } else {
                memos[isbn] = text
            }
            UserDefaults.standard.setValue(memos, forKey: "memo")
            memo = fetchMemo(isbn)
        } else {
            let firstMemo: [String:String] = [isbn:text]
            UserDefaults.standard.setValue(firstMemo, forKey: "memo")
        }
        completion(true)
    }
}



