//
//  BooksTableViewCell.swift
//  BookShelf
//
//  Created by 박균호 on 2021/03/05.
//

import UIKit

class BooksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookSubTitle: UILabel!
    @IBOutlet weak var bookPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(item: Book?) {
        bookImage.setImageURL(item?.image)
        bookTitle.text = item?.title
        bookSubTitle.text = item?.subtitle
        bookPrice.text = item?.price
    }
}



