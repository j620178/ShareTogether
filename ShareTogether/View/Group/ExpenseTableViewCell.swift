//
//  ExpenseTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var insetContentView: UIView! {
        didSet {
            //insetContentView.layer.cornerRadius = 10
//            insetContentView.layer.shadowOpacity = 0.8
//            insetContentView.layer.shadowRadius = 5
//            insetContentView.layer.shadowOffset = .zero
//            insetContentView.layer.shadowColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        }
    }

    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = 10
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            let tempColor = self.insetContentView.backgroundColor
            UIView.animate(withDuration: 0.5) {
                self.insetContentView.backgroundColor = UIColor.lightGray
                self.insetContentView.backgroundColor = tempColor
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
