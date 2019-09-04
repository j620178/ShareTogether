//
//  NewGroupCollectionViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class NewGroupCollectionViewCell: UICollectionViewCell {
    
    private let borderLayer = CAShapeLayer()
    
    @IBOutlet weak var containerView: UIView! {
        didSet {

            borderLayer.strokeColor = UIColor.lightGray.cgColor
            borderLayer.lineDashPattern = [3, 3]
            borderLayer.fillColor = UIColor.backgroundLightGray.cgColor
            containerView.layer.addSublayer(borderLayer)
    
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 10).cgPath
    }

}
