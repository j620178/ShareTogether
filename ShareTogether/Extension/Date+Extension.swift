//
//  Date+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/15.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

extension Date {

    var toDay: Int {
        
        let cal = Calendar.current
        
        return cal.component(.day, from: self)
    }
    
    var toWeekday: Int {
        
        let cal = Calendar.current
        
        return cal.component(.weekday, from: self)
    }

}
