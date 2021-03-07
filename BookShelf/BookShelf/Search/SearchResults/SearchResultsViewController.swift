//
//  SearchResultsViewController.swift
//  BookShelf
//
//  Created by 박균호 on 2021/03/05.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.stopAnimating()
        
        return activityIndicator
    }()
    
    
    let searchManager = SearchManager.sharedInstance
    var keyword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        
        self.view.addSubview(self.activityIndicator)
        
        fetchBooks()
    }
    
    func fetchBooks() {
        activityIndicator.startAnimating()
        searchManager.fetchBooks(keyword) { books in
            DispatchQueue.main.async {
                self.searchResultsTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchManager.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookTableViewCell") as? BooksTableViewCell else {
            return UITableViewCell()
        }
        
        let book = searchManager.books[indexPath.row]
        cell.updateUI(item: book)
        
        return cell
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailStoryboard = UIStoryboard.init(name: "Detail", bundle: nil)
        guard let detailVC = detailStoryboard.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController else { return }
        detailVC.isbn13 = searchManager.books[indexPath.row].isbn13
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
