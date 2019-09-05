//
//  TextFieldTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate: AnyObject {
    func keyboardIsShow(tableViewCell: TextFieldTableViewCell)
}

class TextFieldTableViewCell: UITableViewCell {
    
    weak var delegate: TextFieldTableViewCellDelegate?

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.layer.cornerRadius = 10.0
            textField.clipsToBounds = true
            textField.leftViewMode = .always
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
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
    
}
