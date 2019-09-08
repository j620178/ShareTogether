//
//  ActiveTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
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
        
        categoryImageView.layer.cornerRadius = categoryImageView.frame.height / 10
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
}
