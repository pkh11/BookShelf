//
//  DetailViewController.swift
//  BookShelf
//
//  Created by 박균호 on 2021/03/07.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as? TitleCell else {
                return UITableViewCell()
            }
            cell.updateUI()
            return cell
        }
        if section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "publishCell") as? PublishCell else {
                return UITableViewCell()
            }
            cell.updateUI()
            return cell
        }
        if section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell") as? DescriptionCell else {
                return UITableViewCell()
            }
            cell.updateUI()
            return cell
        }
        return tableView.cellForRow(at: indexPath)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}

extension DetailViewController: UITableViewDelegate {
    
}
