//
//  CategoryCollectionViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    func setupImage(image: UIImage, color: UIColor) {
        categoryImageView.image = image
        if color == .white {
            contentView.backgroundColor = .whiteAlphaOf(0.2)
        } else {
            contentView.backgroundColor = .white
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = contentView.frame.height / 2
    }
    
}
