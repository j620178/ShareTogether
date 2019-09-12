//
//  ExpenseRecode.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

struct Expense {
    let type: String = "ios-car"
    let title: String
    let userId: String = "j620178@gmail.com"
    let userImg: String = "6k0AHYffqONeD4g9fNDrSBtLttC3"
    let userName: String = "Pony"
    let time: String
    let amount: Double
}

struct HomeExpenseCellViewModel {
    let type: String
    let title: String
    let userImg: String
    let time: String
    let amount: Double
    var isFirst: Bool = false
    var isLast: Bool = false
}
