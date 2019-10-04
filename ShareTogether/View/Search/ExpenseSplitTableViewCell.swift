//
//  ExpenseSplitTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/30.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct ExpenseSplitCellViewModel {
    let userImageURL: String?
    let userName: String
}

class ExpenseSplitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var viewModel: ExpenseSplitCellViewModel? {
        didSet {
            userImageView.setUrlImage(viewModel?.userImageURL)
            userNameLabel.text = viewModel?.userName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
}
