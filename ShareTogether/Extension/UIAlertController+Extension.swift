//
//  UIAlertController+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func deleteAlert(handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let  alertVC = UIAlertController()
        
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive, handler: handler)
        alertVC.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        
        return alertVC
    }
    
}
