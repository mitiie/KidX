//
//  SettingTableCell.swift
//  DIYWallpaper
//
//  Created by mitie on 24/3/26.
//

import UIKit

class SettingTableCell: UITableViewCell {
    @IBOutlet weak var icSetting: UIImageView!
    @IBOutlet weak var settingLabel: CommonLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with item: SettingItem) {
        icSetting.image = UIImage(named: item.iconName)
        settingLabel.text = item.title
    }
}
