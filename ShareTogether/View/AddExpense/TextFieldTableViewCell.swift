//
//  TextFieldTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate: AnyObject {
    func didBeginEditing(cell: TextFieldTableViewCell)
    func didEndEditing(cell: TextFieldTableViewCell, text: String?)
}

class TextFieldTableViewCell: UITableViewCell {
    
    var didBeginEditing: (() -> Void)?
    
    weak var delegate: TextFieldTableViewCellDelegate?

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.layer.cornerRadius = 10.0
            textField.clipsToBounds = true
            textField.delegate = self
            textField.addLeftSpace()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .none
    }
    
}

extension TextFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        delegate?.didBeginEditing(cell: self)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        delegate?.didEndEditing(cell: self, text: textField.text)
        
    }
    
}
