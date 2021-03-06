//
//  SearchKeywordsTableViewCell.swift
//  BookShelf
//
//  Created by 박균호 on 2021/03/05.
//

import UIKit

class SearchKeywordsTableViewCell: UITableViewCell {

    @IBOutlet weak var keywordTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(item: Keyword?) {
        guard let keyword = item else { return }
        keywordTitle.text = keyword.query
    }
}
