//
//  FlashCardCell.swift
//  MV_2570
//
//  Created by Bui Minh Tien on 30/6/25.
//

import UIKit

class FlashCardCell: UICollectionViewCell {
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteIMG: UIImageView!
    @IBOutlet weak var markIMG: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    
    var onAddTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        noteIMG.layer.cornerRadius = 36
        noteIMG.backgroundColor = UIColor(hex: 0xFCB8B4, alpha: 0.5)
        btnAdd.isHidden = true
    }

    func configure(with item: FlashCardItem) {
        noteTitle.text = item.title
        if let image = UIImage(contentsOfFile: imagePath(item.imageName)) {
            noteIMG.image = image
        } else {
            noteIMG.image = UIImage(named: item.imageName)
        }

        markIMG.image = item.isRemembered ? UIImage(resource: .starSelected) : UIImage(resource: .starUnselected)
    }

    @IBAction func btnAddTapped(_ sender: UIButton) {
        onAddTapped?()
    }

    private func imagePath(_ filename: String) -> String {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return doc.appendingPathComponent(filename).path
    }
}
