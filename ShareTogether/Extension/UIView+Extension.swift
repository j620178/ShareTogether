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
        cornerRadius: CGFloat = 10,
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
    
    func addShadow(shadowOpacity: Float = 0.25, shadowRadius: CGFloat = 3.0) {
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
        
    }
    
    func addCornerRadius(
        cornerRadius: CGFloat = 10,
        maskedCorners: CACornerMask = [
        .layerMinXMinYCorner,
        .layerMaxXMinYCorner,
        .layerMaxXMaxYCorner,
        .layerMinXMaxYCorner
        ]) {
        
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
        
    }
    
}
