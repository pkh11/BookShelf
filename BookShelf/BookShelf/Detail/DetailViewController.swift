//
//  DetailViewController.swift
//  BookShelf
//
//  Created by 박균호 on 2021/03/07.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.stopAnimating()
        
        return activityIndicator
    }()
    
    var searchManager = SearchManager.sharedInstance
    var isbn13: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(self.activityIndicator)
        
        fetchDetailOfBook(isbn13)
    }
    
    func fetchDetailOfBook(_ isbn13: String) {
        activityIndicator.startAnimating()
        searchManager.fetchDetailOfBook(isbn13) { data in
            DispatchQueue.main.async {
                self.detailTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func share(_ sender: UIButton) {
        if let item = searchManager.book?.url {
            let activityViewController = UIActivityViewController(activityItems: ["\(item)"], applicationActivities: nil)
            self.dismiss(animated: true, completion: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func openBookLink(_ sender: Any) {
        if let book = searchManager.book,
           let url = URL(string: book.url) {
            UIApplication.shared.openURL(url)
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = searchManager.book
        let section = indexPath.section
        
        if section == 0 {
            guard let titleCell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as? TitleCell else {
                return UITableViewCell()
            }
            titleCell.updateUI(detail: item)
            titleCell.selectionStyle = .none
            return titleCell
        }
        if section == 1 {
            guard let publishCell = tableView.dequeueReusableCell(withIdentifier: "publishCell") as? PublishCell else {
                return UITableViewCell()
            }
            publishCell.updateUI(detail: item)
            publishCell.selectionStyle = .none
            return publishCell
        }
        if section == 2 {
            guard let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as? DescriptionCell else {
                return UITableViewCell()
            }
            descriptionCell.updateUI(detail: item)
            descriptionCell.selectionStyle = .none
            return descriptionCell
        }
        if section == 3 {
            guard let memoCell = tableView.dequeueReusableCell(withIdentifier: "memoCell") as? MemoCell else {
                return UITableViewCell()
            }
            memoCell.selectionStyle = .none
            return memoCell
        }
        return tableView.cellForRow(at: indexPath) ?? UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 200
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
}

extension DetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let memoStoryboard = UIStoryboard.init(name: "Memo", bundle: nil)
            guard let memoVC = memoStoryboard.instantiateViewController(withIdentifier: "memoViewController") as? MemoViewController else { return }
            memoVC.isbn13 = isbn13
            self.navigationController?.pushViewController(memoVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
