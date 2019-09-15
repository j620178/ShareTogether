//
//  GroupCollectionViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/2.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct GroupCellViewModel {
    let name: String
    let groupID: String
    let isCurrent: Bool
}

class GroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var groupImageView: UIImageView!
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var isSelectedImageView: UIImageView! {
        didSet {
            isSelectedImageView.backgroundColor = UIColor.STBlack.withAlphaComponent(0.25)
        }
    }
    
    var cellViewModel: GroupCellViewModel? {
        didSet {
            //groupImageView = groupID
            groupNameLabel.text = cellViewModel?.name
            //isSelectedImageView =
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = .init(width: 0, height: 4)
        layer.shadowRadius = 12
        backgroundColor = .clear

    }
}
