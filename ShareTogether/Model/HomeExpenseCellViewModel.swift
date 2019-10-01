//
//  ExpenseRecode.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class HomeExpenseCellViewModel: NSObject {
    let id: String
    let type: ExpenseType
    let title: String
    let userImg: String?
    let time: String
    let amount: Double
    
    init(id: String,
         type: ExpenseType,
         title: String,
         img: String?,
         time: String,
         amount: Double) {
        self.id = id
        self.type = type
        self.title = title
        self.userImg = img
        self.time = time
        self.amount = amount
    }
}
