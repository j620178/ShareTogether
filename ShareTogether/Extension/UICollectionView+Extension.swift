//
//  UICollectionView+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/2.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerWithNib(indentifer: String, bundle: Bundle? = nil) {
        let nib = UINib(nibName: indentifer, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: indentifer)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
