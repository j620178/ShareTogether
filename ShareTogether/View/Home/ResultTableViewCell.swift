//
//  ResultTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct ResultCellViewModel {
    let leftUesrImageURL: String
    let leftUesrName: String
    let rightUesrImageURL: String
    let rightUesrName: String
    let amount: Double
}

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var insideContentView: UIView!
    
    @IBOutlet weak var leftUserImageView: UIImageView!
    
    @IBOutlet weak var leftUserLabel: UILabel!
    
    @IBOutlet weak var rightUserLabel: UILabel!
    
    @IBOutlet weak var rightUserImageView: UIImageView!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var payImageView: UIImageView! {
        didSet {
            payImageView.image = .getIcon(code: "ios-arrow-round-forward", color: .STBlack, size: 30)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupContent(leftUserImageURL: String?,
                      leftUserName: String,
                      rightUserImageURL: String?,
                      rightUserName: String,
                      amount: String) {
        
        leftUserImageView.setUrlImage(leftUserImageURL)
        leftUserLabel.text = leftUserName
        rightUserImageView.setUrlImage(rightUserImageURL)
        rightUserLabel.text = rightUserName
        amountLabel.text = amount
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.insideContentView.addCornerRadius()
        
        leftUserImageView.layer.cornerRadius = leftUserImageView.frame.height / 2
        
        rightUserImageView.layer.cornerRadius = leftUserImageView.frame.height / 2

    }
    
}
