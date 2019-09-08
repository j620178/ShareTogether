//
//  UITableView+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func registerWithNib(indentifer: String, bundle: Bundle? = nil) {
        let nib = UINib(nibName: indentifer, bundle: bundle)
        register(nib, forCellReuseIdentifier: indentifer)
    }
}

extension UITableViewCell {
    static var identifer: String {
        return String(describing: self)
    }
}
