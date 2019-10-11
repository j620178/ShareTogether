//
//  UITabBarItem.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/11.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    static func customItem(button: UIButton, code: String) -> UIBarButtonItem {
        
        button.setImage(.getIcon(code: code, color: .STDarkGray, size: 40), for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        button.layer.cornerRadius = 20
        
        button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        return UIBarButtonItem(customView: button)
    }
}
