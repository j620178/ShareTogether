//
//  TextFieldTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    var amountPassHandler: ((Int) -> Void)?
    
    var descPassHandler: ((Int) -> Void)?

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.layer.cornerRadius = 10.0
            textField.clipsToBounds = true
            textField.addLeftSpace()
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
        self.selectionStyle = .none
    }
    
}
