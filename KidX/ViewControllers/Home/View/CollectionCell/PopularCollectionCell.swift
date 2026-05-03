//
//  PopularCollectionCell.swift
//  MV_2570
//
//  Created by Bui Minh Tien on 29/6/25.
//

import UIKit

class PopularCollectionCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(title: String, imageName: String) {
        categoryLabel.text = title
        categoryImageView.image = UIImage(named: imageName)
    }
}
