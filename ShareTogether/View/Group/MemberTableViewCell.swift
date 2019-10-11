//
//  MemberTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/5.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct MemberCellViewModel {
    
    let userImageURL: String?
    
    let userName: String
    
    let userDetail: String
}

class MemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var indicator: UIImageView!
    
    var viewModel: MemberCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            userImageView.setUrlImage(viewModel.userImageURL)
            
            userNameLabel.text = viewModel.userName
            
            detailLabel.text = viewModel.userDetail
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userNameLabel.textColor = .STDarkGray
        userNameLabel.textColor = .STDarkGray
        indicator.setIcon(code: "ios-arrow-forward", color: .STGray)
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
}
