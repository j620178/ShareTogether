//
//  String+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func getSizeFromString(withFont font: UIFont = .systemFont(ofSize: 15)) -> CGSize {
        let textSize = NSString(string: self).size(withAttributes: [NSAttributedString.Key.font: font])
        return textSize
    }
}
