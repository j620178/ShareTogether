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
    
    @IBOutlet weak var imageContainerView: UIView!
    
    @IBOutlet weak var expenseTypeImageView: UIImageView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var expenseTitleLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var userImageTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userImageBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    var viewModel: HomeExpenseCellViewModel? {
        didSet {
            
            guard let viewModel = viewModel else { return }
            
            expenseTypeImageView.image = .getIcon(code: viewModel.type,
                                                  color: .STTintColor,
                                                  size: 45)
            expenseTitleLabel.text = viewModel.title
            amountLabel.text = String(viewModel.amount)
            timeLabel.text = viewModel.time
            
            resetLayout()
            
            if viewModel.isFirst {
                self.setupFirstCellLayout()
            }
            
            if viewModel.isLast {
                self.setupLastCellLayout()
            }
            
        }
    }
    
    func resetLayout() {
        insetContentView.layer.cornerRadius = 0
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

        imageContainerView.layer.borderWidth = 1
        imageContainerView.layer.borderColor = UIColor.backgroundLightGray.cgColor
        imageContainerView.layer.cornerRadius = imageContainerView.frame.height / 4
        
        expenseTypeImageView.backgroundColor = .white

        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        userImageView.bezierPathBorder(.white, width: 3)
            
    }
    
}
