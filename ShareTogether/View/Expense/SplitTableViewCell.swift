//
//  SplitTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/5.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class SplitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var indicatorImageView: UIImageView!
    
    func updateLabelText(title: String, type: String) {
        titleLabel.text = title
        detailLabel.text = type
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
        
        titleLabel.textColor = .STDarkGray
        detailLabel.textColor = .STDarkGray
        self.selectionStyle = .none
        indicatorImageView.setIcon(code: "ios-arrow-forward", color: .STGray)
    }

}
