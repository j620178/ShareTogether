//
//  TextFieldTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    var infoPassHandler: ((String) -> Void)?
    
    var didBeginEditing: (() -> Void)?

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
        didBeginEditing?()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        
        if string == "" {
            print(text.dropLast())
            infoPassHandler?("\(text.dropLast())")
            
        } else {
            print(text)
            infoPassHandler?(text)
        }
        
        return true
    }
    
}
