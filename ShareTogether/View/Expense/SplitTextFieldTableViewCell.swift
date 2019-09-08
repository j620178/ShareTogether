//
//  SplitTextFieldTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/9.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class SplitTextFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var unitLabel: UILabel!
   
    @IBOutlet weak var textField: UITextField!
    
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
        
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userNameLabel.textColor = .STBlack
        textField.textColor = .STBlack
    }
    
}
