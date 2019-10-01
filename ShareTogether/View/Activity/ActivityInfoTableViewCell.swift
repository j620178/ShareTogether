//
//  ActiveTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ActivityInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
        
    var cellViewModel: ActivityCellViewModel? {
        didSet {
            guard let cellViewModel = cellViewModel else { return }
            
            categoryImageView.setUrlImage(cellViewModel.mainPhotoImageURL)
            userImageView.setUrlImage(cellViewModel.userImageURL)
            contentLabel.text = cellViewModel.desc
            timeLabel.text = cellViewModel.time
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
        
        categoryImageView.layer.cornerRadius = categoryImageView.frame.height / 10
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
}
