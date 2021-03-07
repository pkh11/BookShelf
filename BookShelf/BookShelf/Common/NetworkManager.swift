//
//  NetworkManager.swift
//  BookShelf
//
//  Created by 박균호 on 2021/03/05.
//

import Foundation


class NetworkManager {
    static let sharedInstance = NetworkManager()
    let api = API.sharedInstance
    private var session = URLSession.shared
    
    private init() { }
    
    func getBookList(_ query: String, completion: @escaping (Searh?) -> Void) {
        guard let url = URL(string: "\(api.SEARCH)/\(query)")  else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data,
               let reponseData = response as? HTTPURLResponse {
                if reponseData.statusCode == 200 {
                    let decoder = JSONDecoder()
                    if let jsonData = try? decoder.decode(Searh.self, from: data) {
                        completion(jsonData)
                    }
                } else {
                    print("Status Code is not 200")
                }
            }
        }.resume()
    }
    
    func getBook(_ isbn13: String, completion: @escaping (Detail?) -> Void) {
        guard let url = URL(string: "\(api.DETAIL)/\(isbn13)")  else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data,
                let reponseData = response as? HTTPURLResponse {
                if reponseData.statusCode == 200 {
                    let decoder = JSONDecoder()
                    if let jsonData = try? decoder.decode(Detail.self, from: data) {
                        completion(jsonData)
                    }
                } else {
                    print("Status Code is not 200")
                }
            }
        }.resume()
    }
}

class API {
    static let sharedInstance = API()
    let HOST = "https://api.itbook.store/1.0"
    var SEARCH: String {
        return "\(HOST)/search"
    }
    var DETAIL: String {
        return "\(HOST)/books"
    }
    
    private init() {}
}
