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

extension UIView {
    
    fileprivate var bezierPathIdentifier: String { return "bezierPathBorderLayer" }
    
    fileprivate var bezierPathBorder: CAShapeLayer? {
        return (self.layer.sublayers?.filter({ (layer) -> Bool in
            return layer.name == self.bezierPathIdentifier && (layer as? CAShapeLayer) != nil
        }) as? [CAShapeLayer])?.first
    }
    
    func bezierPathBorder(_ color: UIColor = .white, width: CGFloat = 1) {
        
        var border = self.bezierPathBorder
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        if border == nil {
            border = CAShapeLayer()
            border!.name = self.bezierPathIdentifier
            self.layer.addSublayer(border!)
        }
        
        border!.frame = self.bounds
        let pathUsingCorrectInsetIfAny =
            UIBezierPath(roundedRect: border!.bounds, cornerRadius: self.layer.cornerRadius)
        
        border!.path = pathUsingCorrectInsetIfAny.cgPath
        border!.fillColor = UIColor.clear.cgColor
        border!.strokeColor = color.cgColor
        border!.lineWidth = width * 2
    }
    
    func removeBezierPathBorder() {
        self.layer.mask = nil
        self.bezierPathBorder?.removeFromSuperlayer()
    }
    
}
