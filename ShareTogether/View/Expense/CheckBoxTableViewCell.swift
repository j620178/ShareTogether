//
//  RadioBoxTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/5.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class CheckBoxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    func updateCheckBoxImage(isSelectd: Bool) {
        if isSelectd {
            checkBoxImageView.setIcon(code: "ios-checkmark-circle", color: .white)
        } else {
            checkBoxImageView.setIcon(code: "ios-radio-button-off", color: .white)
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
}
