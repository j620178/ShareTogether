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
    
    @IBOutlet weak var userImageTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userImageBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setupFirstCellLayout(cornerRadius: CGFloat = 10) {
        
//        let constant = userImageTopConstraint.constant
//
//        userImageTopConstraint.isActive = false
//        userImageTopConstraint.constant = constant * 2
//        userImageTopConstraint.isActive = true
//
//        layoutIfNeeded()

        insetContentView.layer.cornerRadius = cornerRadius
        insetContentView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
    }
    
    func setupLastCellLayout(cornerRadius: CGFloat = 10) {
//        let constant = userImageBottomConstraint.constant
//
//        userImageBottomConstraint.isActive = false
//        userImageBottomConstraint.constant = constant * 2
//        userImageBottomConstraint.isActive = true

        insetContentView.layer.cornerRadius = cornerRadius
        insetContentView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        
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
        
//        contentView.layer.masksToBounds = true
//        contentView.layer.cornerRadius = 16
        
//        layer.masksToBounds = false
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.25
//        layer.shadowOffset = CGSize(width: -1, height: 1)
//        layer.shadowRadius = 8
//        backgroundColor = .clear
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
}
