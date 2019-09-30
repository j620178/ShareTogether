//
//  Double+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

extension Double {
    
    var toAmountText: String {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        
        if (self - Double(Int(self))) == 0 {
            formatter.minimumFractionDigits = 0
            return formatter.string(from: NSNumber(value: Int(self)))!
        } else {
            formatter.minimumFractionDigits = 1
            return formatter.string(from: NSNumber(value: self))!
        }
                
    }

}
