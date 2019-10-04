//
//  SplitTextFieldTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/9.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol SplitTextFieldCellDelegate: AnyObject {
    func splitTextFieldTableViewCell(cell: SplitTextFieldTableViewCell, didChangeText: String)
}

class SplitTextFieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var unitLabel: UILabel!
   
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.addTarget(self, action: #selector(tapTextField(_:)), for: .editingChanged)
        }
    }
    
    weak var delegate: SplitTextFieldCellDelegate?
    
    func setupContent(text: String?, name: String, photoURL: String?, unit: String) {
        
        textField.text = text
        userNameLabel.text = name
        userImageView.setUrlImage(photoURL)
        unitLabel.text = unit
        
    }
    
    @objc func tapTextField(_ sender: UITextField) {
        delegate?.splitTextFieldTableViewCell(cell: self, didChangeText: sender.text ?? "")
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
        userNameLabel.textColor = .STBlack
        textField.textColor = .STBlack
    }
    
}
