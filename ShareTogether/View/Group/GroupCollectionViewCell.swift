//
//  GroupCollectionViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/2.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var groupImage: UIImageView!
    
    @IBOutlet weak var selectedImageView: UIImageView! {
        didSet {
            selectedImageView.backgroundColor = .blackAlphaOf(0.25)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectedImageView.layer.cornerRadius = selectedImageView.frame.height / 2
    }
}
