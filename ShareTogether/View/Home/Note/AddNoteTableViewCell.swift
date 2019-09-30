//
//  AddNoteTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/1.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class AddNoteTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
}
