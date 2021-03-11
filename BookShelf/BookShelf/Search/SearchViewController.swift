//
//  ViewController.swift
//  BookShelf
//
//  Created by 박균호 on 2021/03/05.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let searchManager = SearchManager.sharedInstance
    var resultsView: SearchResultsViewController!
    var filteredKeywords = [Keyword]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        
    }
    
    func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        self.navigationItem.titleView = searchBar
    }
    
    @IBAction func removeKeywords(_ sender: Any) {
        
        let alertAction = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveAction = UIAlertAction(title: "최근 검색 지우기", style: .default) {_ in
            self.searchManager.removeKeywords()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { _ in }
        
        alertAction.addAction(saveAction)
        alertAction.addAction(cancelAction)
        
        self.present(alertAction, animated: true, completion: nil)
    }
}

extension SearchViewController {
    func moveToResultViewController(_ keyword: String) {
        let storyboard = UIStoryboard(name: "SearchResults", bundle: nil)
        guard let searchResultsViewController = storyboard.instantiateViewController(withIdentifier: "searchResultsViewController") as? SearchResultsViewController else {
            return
        }
        
        resultsView = searchResultsViewController
        resultsView.keyword = keyword
        self.addChild(resultsView)
        self.view.frame = resultsView.view.frame
        self.view.addSubview(resultsView.view)
        resultsView.didMove(toParent: self)
    }
    
    func isFiltering() -> Bool {
        return !(searchBar.text?.isEmpty ?? true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let text = searchBar.text {
            filteredKeywords = searchManager.keywords.filter({ (keyword) -> Bool in
                return keyword.query.lowercased().contains((text.lowercased()))
            })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let resultViewController = resultsView {
            resultViewController.view.removeFromSuperview()
            resultViewController.removeFromParent()
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let resultViewController = resultsView {
            resultViewController.view.removeFromSuperview()
            resultViewController.removeFromParent()
        }
        if let keyword = searchBar.text {
            moveToResultViewController(keyword)
            searchManager.setKeyword(keyword)
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredKeywords.count
        }
        return searchManager.keywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recentKeywordsTableviewCell") as? SearchKeywordsTableViewCell else {
            return UITableViewCell()
        }
        
        if isFiltering() {
            let filteredKeyword = filteredKeywords[indexPath.row]
            cell.updateUI(item: filteredKeyword)
        } else {
            let keyword = searchManager.keyword(at: indexPath.row)
            cell.updateUI(item: keyword)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var text = ""
        
        if isFiltering() {
            let filteredKeyword = filteredKeywords[indexPath.row]
            text = filteredKeyword.query
        } else {
            if let keyword = searchManager.keyword(at: indexPath.row) {
                text = keyword.query
            }
        }
        
        searchBar.text = text
        moveToResultViewController(text)
        searchManager.setKeyword(text)
    }
}
