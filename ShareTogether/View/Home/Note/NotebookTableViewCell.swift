//
//  NotebookTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/5.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct NotebookCellViewModel {
    var userImageURL: String?
    var userName: String
    var content: String
    var commentCount: Int
    var time: String
}

class NotebookTableViewCell: UITableViewCell {

    @IBOutlet weak var insetContentView: UIView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton! {
        didSet {
            moreButton.setImage(.getIcon(code: "ios-more",
                                         color: .darkGray,
                                         size: 30),
                                for: .normal)
        }
    }
    
    @IBAction func clickMoreButton(_ sender: UIButton) {
        clickMoreButtonHandler?()
    }
    
    var clickMoreButtonHandler: (() -> Void)?
    
    var cellViewModel: NotebookCellViewModel? {
        didSet {
            guard let cellViewModel = cellViewModel else { return }
            userImage.setUrlImage(cellViewModel.userImageURL ?? "")
            userNameLabel.text = cellViewModel.userName
            contentLabel.text = cellViewModel.content
            commentCountLabel.text = cellViewModel.commentCount > 0 ? "\(cellViewModel.commentCount) 個留言" : nil
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
        
        userImage.layer.cornerRadius = userImage.frame.height / 2
    }
    
}
