//
//  ExpenseRecode.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class HomeExpenseCellViewModel: NSObject {
    let type: ExpenseType
    let title: String
    let userImg: String
    let time: String
    let amount: Double
    var isFirst: Bool
    var isLast: Bool
    
    init(type: ExpenseType,
         title: String,
         img: String,
         time: String,
         amount: Double,
         isFirst: Bool = false,
         isLast: Bool = false) {
        self.type = type
        self.title = title
        self.userImg = img
        self.time = time
        self.amount = amount
        self.isFirst = isFirst
        self.isLast = isLast
    }
}
