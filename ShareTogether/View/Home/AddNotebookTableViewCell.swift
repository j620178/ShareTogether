//
//  AddNotebookTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/10.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class AddNotebookTableViewCell: UITableViewCell {

    @IBOutlet weak var insetContentView: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
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
        insetContentView.layer.cornerRadius = insetContentView.frame.height / 4
    }
    
}
