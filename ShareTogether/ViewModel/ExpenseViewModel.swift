//
//  ExpenseRecodeViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

class HomeExpenseViewModel: NSObject {
    
    let expenses = [
        [
            Expense(title: "門票", time: "2018/8/27", amount: 1200),
            Expense(title: "租車", time: "2018/8/27", amount: 16000),
            Expense(title: "地鐵", time: "2018/8/27", amount: 25)
        ], [
            Expense(title: "機票", time: "2018/9/4", amount: 36000),
            Expense(title: "租車", time: "2018/8/27", amount: 16000),
            Expense(title: "門票", time: "2018/8/27", amount: 1200),
            Expense(title: "Pass", time: "2018/8/27", amount: 360),
            Expense(title: "地鐵", time: "2018/8/27", amount: 25)
        ]
    ]
    
    private var cellViewModels = [[HomeExpenseCellViewModel]]()
    
    var reloadTableViewClosure: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?
    
    var numberOfSections: Int {
        return cellViewModels.count
    }
    
    func numberOfCells(section: Int) -> Int {
        return cellViewModels[section].count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> HomeExpenseCellViewModel {
        
        if indexPath.row == 0 {
            cellViewModels[indexPath.section][indexPath.row].isFirst = true
            return cellViewModels[indexPath.section][indexPath.row]
        } else {
            for section in cellViewModels.indices {
                let lastIndexPath = IndexPath(row: cellViewModels[section].count - 1, section: section)
                if indexPath == lastIndexPath {
                    cellViewModels[indexPath.section][indexPath.row].isLast = true
                    return cellViewModels[indexPath.section][indexPath.row]
                }
            }
        }
        
        return cellViewModels[indexPath.section][indexPath.row]
    }
    
    func createCellViewModels(expense: Expense) -> HomeExpenseCellViewModel {
        
        return HomeExpenseCellViewModel(type: expense.type,
                                        title: expense.title,
                                        userImg: expense.userImg,
                                        time: expense.time,
                                        amount: expense.amount,
                                        isFirst: false,
                                        isLast: false)
    }
    
    func processData() {
        var cellViewModels = [[HomeExpenseCellViewModel]]()
        
        for selection in expenses {
            
            var viewModelsInSelection = [HomeExpenseCellViewModel]()
            
            for expense in selection {
                viewModelsInSelection.append(createCellViewModels(expense: expense))
            }
            
            cellViewModels.append(viewModelsInSelection)
        }
        
        self.cellViewModels = cellViewModels
    }
    
}
