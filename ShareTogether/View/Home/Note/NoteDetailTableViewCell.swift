//
//  NoteDetailTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct NoteDetailCellViewModel {
    let userImageURL: String?
    let userName: String
    let content: String
    let time: String
}

class NoteDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var viewModel: NoteDetailCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            userImageView.setUrlImage(viewModel.userImageURL ?? "")
            userNameLabel.text = viewModel.userName
            contentLabel.text =  viewModel.content
            timeLabel.text = viewModel.time
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
