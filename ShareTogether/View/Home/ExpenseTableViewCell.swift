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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    var viewModel: HomeExpenseCellViewModel? {
        didSet {
            
            guard let viewModel = viewModel else { return }
            
            expenseTypeImageView.image = viewModel.type.getImage(color: .STTintColor)
            userImageView.setUrlImage(viewModel.userImg)
            expenseTitleLabel.text = viewModel.title
            amountLabel.text = viewModel.amount.toAmountText
            timeLabel.text = viewModel.time
            
        }
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
