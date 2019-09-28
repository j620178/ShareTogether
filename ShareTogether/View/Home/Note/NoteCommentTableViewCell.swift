//
//  NoteCommentTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct NoteCommentCellViewModel {
    let userImageURL: String
    let userName: String
    let content: String
    let time: String
}

class NoteCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var viewModel: NoteCommentCellViewModel? {
        didSet {
            self.userImageView.setUrlImage(viewModel?.userImageURL ?? "")
            self.userName.text = viewModel?.userName
            self.content.text = viewModel?.content
            self.timeLabel.text = viewModel?.time
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
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }

}
