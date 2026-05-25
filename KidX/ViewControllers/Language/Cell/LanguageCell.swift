//
//  LanguageCell.swift
//  BaseApp
//
//  Created by Tran Van Quang on 5/3/26.
//

import UIKit

class LanguageCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var ivFlag: UIImageView!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var ivSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(_ language: LanguageModel, _ selectedLanguage: LanguageModel?) {
        let isSelected = selectedLanguage?.code == language.code
        self.ivFlag.image = UIImage(named: language.flag)
        self.lblLanguage.text = language.display
        self.ivSelected.image = UIImage(named: isSelected ? "ic_flag_selected" : "ic_flag_unselect")
        self.mainView.circleCorner = true
        self.mainView.layer.borderColor = !isSelected ? UIColor.clear.cgColor : AppColor.primary.color.cgColor
        self.mainView.layer.borderWidth = 1
        self.mainView.layer.masksToBounds = true
    }
    
    static var height: CGFloat {
        return 68.0
    }
}
