//
//  ExpenseRecodeViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class ExpenseRecodeViewModel {
    let itemsString = ["交易紀錄", "金額統計", "結算結果", "地圖", "活動紀錄"]
    
    private var expenseRecodes = [ExpenseRecode]()
    
    private var cellViewModels: [ExpenseRecodeCellViewModel] = [ExpenseRecodeCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadTableViewClosure: (()->())?
    
//    func initFetch() {
//        let data = [ExpenseRecode(userId: "j620178", userImg: "12", userName: "littlema", time: "2018/10/02", title: "早餐", amount: 20),
//                    ExpenseRecode(userId: "j620178", userImg: "12", userName: "littlema", time: "2018/10/02", title: "早餐", amount: 20),
//                    ExpenseRecode(userId: "j620178", userImg: "12", userName: "littlema", time: "2018/10/02", title: "早餐", amount: 20),
//                    ExpenseRecode(userId: "j620178", userImg: "12", userName: "littlema", time: "2018/10/02", title: "早餐", amount: 20)]
//        return data
//    }
//    
    func createCellViewModel(expenseRecode: ExpenseRecode) -> ExpenseRecodeCellViewModel {
    
        return ExpenseRecodeCellViewModel( titleText: expenseRecode.title,
                                       timeText: expenseRecode.time,
                                       imageUrl: expenseRecode.userImg,
                                       amountText: "\(expenseRecode.amount)")
    }
    
    private func processFetchedRecodes(expenseRecodes: [ExpenseRecode]) {
        self.expenseRecodes = expenseRecodes // Cache
        var vms = [ExpenseRecodeCellViewModel]()
        for recode in expenseRecodes {
            vms.append(createCellViewModel(expenseRecode: recode) )
        }
        self.cellViewModels = vms
    }
}

struct ExpenseRecodeCellViewModel {
    let titleText: String
    let timeText: String
    let imageUrl: String
    let amountText: String
}
