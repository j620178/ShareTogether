//
//  HomeViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/20.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class HomeViewModel: NSObject {
    
    var expenses = [Expense]()
    
    @objc dynamic var cellViewModels = [[HomeExpenseCellViewModel]]()
    
    var resultInfo = [String: Double]()
    
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
    
    func getExpenseCellViewModel(at indexPath: IndexPath) -> HomeExpenseCellViewModel {
        
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
    
    func createExpenseCellViewModel(expense: Expense) -> HomeExpenseCellViewModel {
        
        return HomeExpenseCellViewModel(type: ExpenseType(rawValue: expense.type)!,
                                        title: expense.desc,
                                        img: expense.splitInfo.amountDesc[0].member.photoURL,
                                        time: expense.time.toFullFormat(),
                                        amount: expense.amount,
                                        isFirst: false,
                                        isLast: false)
    }
    
    func fectchData() {
        
        FirestoreManager.shared.getExpenses { [weak self] result in
            switch result {
                
            case .success(let expenses):
                
                if expenses.isEmpty {
                    self?.expenses = [Expense]()
                    self?.cellViewModels = [[HomeExpenseCellViewModel]]()
                } else {
                    self?.expenses = expenses
                    self?.processData()
                    self?.createResultInfo()
                }

            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func processData() {
        
        var viewModels = [[HomeExpenseCellViewModel]]()
        
        var viewModelsSection = [HomeExpenseCellViewModel]()
        
        var index = 0
        
        titleOfSections = [String]()
        
        titleOfSections.append(expenses[0].time.toSimpleFormat())
        
        for expense in expenses {
            
            if titleOfSections[index] == expense.time.toSimpleFormat() {
                viewModelsSection.append(createExpenseCellViewModel(expense: expense))
            } else {
                viewModels.append(viewModelsSection)
                titleOfSections.append(expense.time.toSimpleFormat())
                viewModelsSection = [HomeExpenseCellViewModel]()
                viewModelsSection.append(createExpenseCellViewModel(expense: expense))
                index += 1
            }
            
        }
        
        viewModels.append(viewModelsSection)
        
        self.cellViewModels = viewModels
        
    }
    
    func getStatisticsgetCellViewModel() -> StatisticsCellViewModel? {
        
        //    //群組：總消費, 平均消費, 消費筆數
        //    //個人：總消費, 借出, 借入, 已收到 已支付
        
        let count = expenses.count
        
        var total: Double = 0
        
        var selfPay: Double = 0
        
        var selfLend: Double = 0
        
        var selfBorrow: Double = 0
        
        for expense in expenses {
            total += expense.amount
        }
        
        for expense in expenses {
            
            guard let first = expense.payerInfo.amountDesc.first else { return nil }
            
            if first.member.id == UserInfoManager.shaered.currentUserInfo?.id {
                selfPay += expense.amount
            }
        }
        
        for expense in expenses {
            
            guard let first = expense.payerInfo.amountDesc.first else { return nil }
            
            let selfID = UserInfoManager.shaered.currentUserInfo?.id
            
            if first.member.id == selfID {
            
                if SplitType(rawValue: expense.splitInfo.type) == SplitType.average {
                    let pay = expense.amount / Double(expense.splitInfo.amountDesc.filter({$0.value != nil}).count)
                    selfLend += (expense.amount - pay)
                } else if SplitType(rawValue: expense.splitInfo.type) == SplitType.percentage {
                    guard let value = expense.splitInfo.amountDesc.filter({ $0.member.id == selfID}).first?.value
                    else { return nil}
                    selfLend += (expense.amount - (expense.amount * value / 100))
                } else if SplitType(rawValue: expense.splitInfo.type) == SplitType.amount {
                    guard let value = expense.splitInfo.amountDesc.filter({ $0.member.id == selfID}).first?.value
                    else { return nil}
                    selfLend += value
                }
                
            }
                
        }
        
        for expense in expenses {
            
            guard let payer = expense.payerInfo.amountDesc.first else { return nil }
            
            let selfID = UserInfoManager.shaered.currentUserInfo?.id
            
            if payer.member.id != selfID {
            
                if SplitType(rawValue: expense.splitInfo.type) == SplitType.average {
                    let eachPay = expense.amount / Double(expense.splitInfo.amountDesc.filter({$0.value != nil}).count)
                    selfBorrow += (expense.amount - eachPay)
                } else if SplitType(rawValue: expense.splitInfo.type) == SplitType.percentage {
                    guard let percentage = expense.splitInfo.amountDesc.filter({ $0.member.id == selfID}).first?.value
                    else { return nil}
                    let eachPay = (expense.amount * percentage / 100)
                    selfBorrow += (expense.amount - eachPay)
                } else if SplitType(rawValue: expense.splitInfo.type) == SplitType.amount {
                    guard let eachPay = expense.splitInfo.amountDesc.filter({ $0.member.id == selfID}).first?.value
                    else { return nil}
                    selfBorrow += eachPay
                }
                
            }
                
        }
        
        return StatisticsCellViewModel(total: total,
                                       count: count,
                                       selfPay: selfPay,
                                       selfLend: selfLend,
                                       selfBorrow: selfBorrow)
    }
    
    func createResultInfo() {
        
        var result = [String: Double]()
        
        for expense in expenses {
            
            guard let payer = expense.payerInfo.amountDesc.first else { return }
            
            if SplitType(rawValue: expense.splitInfo.type) == SplitType.average {
                
                let pay = expense.amount / Double(expense.splitInfo.amountDesc.filter({$0.value != nil}).count)
                for aDesc in expense.splitInfo.amountDesc where aDesc.member.id != payer.member.id {
                    if result[aDesc.member.id] != nil {
                        result[aDesc.member.id]! += pay
                    } else {
                        result[aDesc.member.id] = pay
                    }
                }
                
            } else if SplitType(rawValue: expense.splitInfo.type) == SplitType.percentage {
                                
                for aDesc in expense.splitInfo.amountDesc where aDesc.member.id != payer.member.id {
                    if result[aDesc.member.id] != nil {
                        result[aDesc.member.id]! += (expense.amount * (aDesc.value ?? 0) / 100)
                    } else {
                        result[aDesc.member.id] = (expense.amount * (aDesc.value ?? 0) / 100)
                    }
                }
                
            } else if SplitType(rawValue: expense.splitInfo.type) == SplitType.amount {
                
                for aDesc in expense.splitInfo.amountDesc where aDesc.member.id != payer.member.id {
                    if result[aDesc.member.id] != nil {
                        result[aDesc.member.id]! += (aDesc.value ?? 0)
                    } else {
                        result[aDesc.member.id] = (aDesc.value ?? 0)
                    }
                }
            }
        
        }
        
        resultInfo = result
        
    }
    
    func getResultInfo(uid: String) -> Double? {
        return resultInfo[uid]
    }

}
