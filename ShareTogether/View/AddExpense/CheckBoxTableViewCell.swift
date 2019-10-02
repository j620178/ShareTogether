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
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    func setupContent(name: String, photoURL: String?) {
        
        userNameLabel.text = name
        userImageView.setUrlImage(photoURL)
        
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        switchIcon(isSelectd: selected)
        // Configure the view for the selected state
    }
    
    func switchIcon(isSelectd: Bool) {
        if isSelectd {
            checkBoxImageView.setIcon(code: "ios-checkmark-circle", color: .STTintColor)
        } else {
            checkBoxImageView.setIcon(code: "ios-radio-button-off", color: .lightGray)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
}
