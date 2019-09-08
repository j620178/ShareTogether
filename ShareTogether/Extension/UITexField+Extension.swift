//
//  UITexField+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/8.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func addLeftSpace() {
        leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    }
}
