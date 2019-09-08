//
//  MemberTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/5.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var indicator: UIImageView!
    
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
        
        indicator.setIcon(code: "ios-arrow-forward", color: .white)
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
}
