//
//  TextFieldTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate: AnyObject {
    func keyboardBeginEditing(tableViewCell: TextFieldTableViewCell)
}

class TextFieldTableViewCell: UITableViewCell {
    
    weak var delegate: TextFieldTableViewCellDelegate?

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
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

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.keyboardBeginEditing(tableViewCell: self)
    }
}
