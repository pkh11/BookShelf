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
    
    func updateUI() {
        
    }
}

class PublishCell: UITableViewCell {
    
    @IBOutlet weak var bookPublisher: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI() {
        
    }
}

class DescriptionCell: UITableViewCell {
    
    @IBOutlet weak var bookDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI() {
        
    }
}
