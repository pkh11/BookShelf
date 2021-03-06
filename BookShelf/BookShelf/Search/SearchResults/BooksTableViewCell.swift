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


class CacheManager {
    static let sharedInstance = NSCache<NSString, UIImage>()
    private init() { }
}

extension UIImageView {
    func setImageURL(_ url: String?) {
        
        guard let url = url else { return }
        
        let cacheKey = NSString(string: url) // 캐시에 사용될 Key 값
        
        if let cachedImage = CacheManager.sharedInstance.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let imageUrl = URL(string: url) {
                URLSession.shared.dataTask(with: imageUrl) { (data, res, err) in
                    if let _ = err {
                        DispatchQueue.main.async {
                            self.image = UIImage()
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if let data = data, let image = UIImage(data: data) {
                            CacheManager.sharedInstance.setObject(image, forKey: cacheKey)
                            self.image = image
                        }
                    }
                }.resume()
            }
        }
    }
}
