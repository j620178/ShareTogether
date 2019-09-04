//
//  UIColor+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var STGray: UIColor {
        return UIColor(red: 102/255, green: 114/255, blue: 130/255, alpha: 1)
    }
    
    static var STBlack: UIColor {
        return UIColor(red: 7/255, green: 24/255, blue: 49/255, alpha: 1)
    }
    
    static var STBlue: UIColor {
        return UIColor(red: 10/255, green: 94/255, blue: 242/255, alpha: 1)
    }
    
    static var STRed: UIColor {
        return UIColor(red: 239/255, green: 0/255, blue: 62/255, alpha: 1)
    }
    
    static var STOrange: UIColor {
        return UIColor(red: 235/255, green: 147/255, blue: 15/255, alpha: 1)
    }
    
    static var STCyan: UIColor {
        return UIColor(red: 33/255, green: 231/255, blue: 191/255, alpha: 1)
    }
    
    static var backgroundLightGray: UIColor {
        return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }
    
    static func whiteAlphaOf(_ alpha: CGFloat) -> UIColor {
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: alpha)
    }
    
    static func blackAlphaOf(_ alpha: CGFloat) -> UIColor {
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: alpha)
    }
    
}
