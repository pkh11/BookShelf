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
    
    var searchController : UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "키워드 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    let searchManager = SearchManager.sharedInstance
    var resultsView: SearchResultsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = true
        
        self.navigationItem.titleView = searchController.searchBar
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
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let resultViewController = resultsView {
            resultViewController.view.removeFromSuperview()
            resultViewController.removeFromParent()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
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
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchManager.keywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recentKeywordsTableviewCell") as? SearchKeywordsTableViewCell else {
            return UITableViewCell()
        }
        
        let keyword = searchManager.keyword(at: indexPath.row)
        cell.updateUI(item: keyword)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let keywords = searchManager.keyword(at: indexPath.row) {
            searchController.searchBar.text = keywords.query
        }
        
    }
}
