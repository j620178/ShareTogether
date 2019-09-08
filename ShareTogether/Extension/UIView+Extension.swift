//
//  UIView+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/6.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addCornerAndShadow(
        cornerRadius: CGFloat,
        maskedCorners: CACornerMask = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner
        ]) {
        
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.20
        layer.shadowRadius = 5.0
        layer.maskedCorners = maskedCorners
        
    }
}

extension UIView {
    func addShadow(shadowOpacity: Float = 0.25) {
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = 3.0
        layer.masksToBounds = false
    
    }
}
