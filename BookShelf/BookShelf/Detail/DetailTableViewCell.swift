//
//  DetailTableViewCell.swift
//  BookShelf
//
//  Created by 박균호 on 2021/03/07.
//

import UIKit

class TitleCell: UITableViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(detail: Detail?) {
        bookImage.setImageURL(detail?.image)
        bookTitle.text = detail?.title
        bookAuthor.text = detail?.authors
        bookPrice.text = detail?.price
    }
}

class PublishCell: UITableViewCell {
    
    @IBOutlet weak var bookPublisher: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(detail: Detail?) {
        bookPublisher.text = detail?.publisher
    }
}

class DescriptionCell: UITableViewCell {
    
    @IBOutlet weak var bookDescription: UITextView!
    @IBOutlet weak var linkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(detail: Detail?) {
        bookDescription.text = detail?.desc
    }
}
