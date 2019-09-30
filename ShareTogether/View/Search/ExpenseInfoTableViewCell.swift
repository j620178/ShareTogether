//
//  ExpenseInfoTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/30.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct ExpenseInfoCellViewModel {
    let desc: String
    let amount: String
    let amountType: ExpenseType
    let groupName: String
    let userImageURL: String
    let payer: String
    let time: String
}

class ExpenseInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var payerLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var amountTypeImageView: UIImageView!
        
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var viewModel: ExpenseInfoCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            descLabel.text = viewModel.desc
            userImageView.setUrlImage(viewModel.userImageURL)
            payerLabel.text = viewModel.payer
            amountLabel.text = viewModel.amount
            timeLabel.text = viewModel.time
            groupNameLabel.text = viewModel.groupName
            amountTypeImageView.image = viewModel.amountType.getImage(color: .STTintColor)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
}
