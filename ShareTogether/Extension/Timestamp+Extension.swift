//
//  Timestamp+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension Timestamp {
    
    var toNowFormat: String {
        let date = self.dateValue()
        let now = Date()
        
        let components = Calendar.current.dateComponents([.day, .minute, .hour],
                                                         from: now,
                                                         to: date)
        
        if let day = components.day, day != 0 {
            return "\(abs(day)) 天前"
        } else if let hour = components.hour, hour != 0 {
            return "\(abs(hour)) 小時前"
        } else if let minute = components.minute, minute != 0 {
            return "\(abs(minute)) 分鐘前"
        } else {
            return "剛剛"
        }
    }
    
    var toFullTimeFormat: String {
        let date = self.dateValue()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
    
    var toFullFormat: String {
        let date = self.dateValue()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    var toSimpleFormat: String {
        let date = self.dateValue()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "M月dd日"
        return formatter.string(from: date)
    }
    
}
