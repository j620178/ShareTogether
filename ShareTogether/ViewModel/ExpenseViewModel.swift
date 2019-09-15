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
    
    var expenses = [Expense]()
    
    private var cellViewModels = [[HomeExpenseCellViewModel]]() {
        didSet {
            reloadTableViewHandler?()
        }
    }
    
    private var titleOfSections = [String]()
    
    var reloadTableViewHandler: (() -> Void)?
    var showAlertHandler: (() -> Void)?
    var updateLoadingStatusHandler: (() -> Void)?
    
    var numberOfSections: Int {
        return cellViewModels.count
    }
    
    func numberOfCells(section: Int) -> Int {
        return cellViewModels[section].count
    }
    
    func titleOfSections(section: Int) -> String {
        return titleOfSections[section]
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> HomeExpenseCellViewModel {
        
        if indexPath.row == 0 {
            //cellViewModels[indexPath.section][indexPath.row].isFirst = true
            return cellViewModels[indexPath.section][indexPath.row]
        } else {
            for section in cellViewModels.indices {
                let lastIndexPath = IndexPath(row: cellViewModels[section].count - 1, section: section)
                if indexPath == lastIndexPath {
                    //cellViewModels[indexPath.section][indexPath.row].isLast = true
                    return cellViewModels[indexPath.section][indexPath.row]
                }
            }
        }
        
        return cellViewModels[indexPath.section][indexPath.row]
    }
    
    func createCellViewModels(expense: Expense) -> HomeExpenseCellViewModel {
        
        return HomeExpenseCellViewModel(type: ExpenseType(rawValue: expense.type)!,
                                        title: expense.title,
                                        userImg: "123",
                                        time: expense.time.toFullFormat(),
                                        amount: expense.amount,
                                        isFirst: false,
                                        isLast: false)
    }
    
    func fectchData() {
        FirestoreManager.shared.getExpenses { [weak self] result in
            switch result {
                
            case .success(let expenses):
                self?.expenses = expenses
                self?.processData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func processData() {
        
        guard expenses.count > 1 else { return }
        
        var viewModels = [[HomeExpenseCellViewModel]]()
        
        var viewModelsSection = [HomeExpenseCellViewModel]()
        
        var index = 0
        
        titleOfSections.append(expenses[0].time.toSimpleFormat())
        
        for expense in expenses {
            
            if titleOfSections[index] == expense.time.toSimpleFormat() {
                viewModelsSection.append(createCellViewModels(expense: expense))
            } else {
                viewModels.append(viewModelsSection)
                titleOfSections.append(expense.time.toSimpleFormat())
                viewModelsSection = [HomeExpenseCellViewModel]()
                viewModelsSection.append(createCellViewModels(expense: expense))
                index += 1
            }
            
        }
        
        viewModels.append(viewModelsSection)
        
        self.cellViewModels = viewModels
        
    }
    
}
