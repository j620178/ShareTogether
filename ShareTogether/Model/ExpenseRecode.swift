//
//  ExpenseRecode.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

struct HomeExpenseCellViewModel {
    let type: ExpenseType
    let title: String
    let userImg: String
    let time: String
    let amount: Double
    var isFirst: Bool = false
    var isLast: Bool = false
}
