//
//  ExpenseTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var insetContentView: UIView!

    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            let tempColor = self.insetContentView.backgroundColor
            UIView.animate(withDuration: 0.5) {
                self.insetContentView.backgroundColor = UIColor.backgroundLightGray
                self.insetContentView.backgroundColor = tempColor
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
}
