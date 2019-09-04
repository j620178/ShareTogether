//
//  SwiftIconFont.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/2.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit
import SwiftIconFont

extension UIImageView {
    
    func setIcon(from: Fonts = .ionicon, code: String, color: UIColor = .STBlack, backgroundColor: UIColor = .clear) {
        self.setIcon(from: from, code: code, textColor: color, backgroundColor: backgroundColor, size: nil)
    }
    
}

extension UIImage {
    
    static let tabbarIconSize = CGSize(width: 30, height: 30)
    
    static func getIcon(
        from: Fonts = .ionicon,
        code: String,
        color: UIColor?,
        backgroundColor: UIColor = .clear,
        size: CGSize) -> UIImage {
        
        if color == nil {
            return UIImage(from: from, code: code, textColor: .STBlack, backgroundColor: backgroundColor, size: size)
        } else {
            return UIImage(
                from: from,
                code: code,
                textColor: color!,
                backgroundColor:
                backgroundColor,
                size: size
            ).withRenderingMode(.alwaysOriginal)
        }
    }
    
    static func getIcon(
        from: Fonts = .ionicon,
        code: String,
        color: UIColor?,
        backgroundColor: UIColor = .clear,
        width: Int,
        height: Int) -> UIImage {
        
        if color == nil {
            return UIImage(
                from: from,
                code: code,
                textColor: .STBlack,
                backgroundColor: backgroundColor,
                size: CGSize(width: width, height: height)
            )
        } else {
            return UIImage(
                from: from,
                code: code,
                textColor: color!,
                backgroundColor: backgroundColor,
                size: CGSize(width: width, height: height)
            ).withRenderingMode(.alwaysOriginal)
        }

    }
    
    static func getIcon(
        from: Fonts = .ionicon,
        code: String,
        color: UIColor?,
        backgroundColor: UIColor = .clear,
        size: Int) -> UIImage {
        
        if color == nil {
            return UIImage(
                from: from,
                code: code,
                textColor: .STBlack,
                backgroundColor: backgroundColor,
                size: CGSize(width: size, height: size)
            )
        } else {
            return UIImage(
                from: from,
                code: code,
                textColor: color!,
                backgroundColor: backgroundColor,
                size: CGSize(width: size, height: size)
            ).withRenderingMode(.alwaysOriginal)
        }
        
    }
    
    static var home: UIImage {
        return UIImage.getIcon(from: .themify, code: "home", color: nil, size: tabbarIconSize)
    }
    
    static var search: UIImage {
        return UIImage.getIcon(from: .themify, code: "search", color: nil, size: tabbarIconSize)
    }
    
    static var add: UIImage {
        return UIImage.getIcon(
            code: "ios-add-circle",
            color: .STBlue,
            size: 50
        )
    }

    static var notifications: UIImage {
        return UIImage.getIcon(from: .themify, code: "bell", color: nil, size: tabbarIconSize)
    }
    
    static var settings: UIImage {
        return UIImage.getIcon(from: .themify, code: "settings", color: nil, size: tabbarIconSize)
    }
    
}
