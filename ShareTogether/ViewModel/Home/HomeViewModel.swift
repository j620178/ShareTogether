//
//  HomeViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/20.
//  Copyright © 2019 littema. All rights reserved.
//
import Foundation

class HomeViewModel: NSObject {
    
    private var expenses = [Expense]()
    
    @objc dynamic var cellViewModels = [[HomeExpenseCellViewModel]]()
    
    var resultInfo = [String: Double]()
    
    var isLoading: Bool = false {
         didSet {
             loadingHandler?(isLoading)
         }
    }
    
    private var titleOfSections = [String]()
    
    var reloadTableViewHandler: (() -> Void)?
    
    var showAlertHandler: (() -> Void)?
    
    var loadingHandler: ((Bool) -> Void)?
    
    var numberOfSections: Int {
        return cellViewModels.count
    }
    
    func numberOfCells(section: Int) -> Int {
        return cellViewModels[section].count
    }
    
    func titleOfSections(section: Int) -> String {
        return titleOfSections[section]
    }
    
    func getExpense(section: Int, row: Int) -> Expense? {
        
        let id = cellViewModels[section][row].id
        
        var result: Expense?
        
        expenses.forEach { expense in
            if expense.id == id {
                result = expense
                return
            }
        }
        
        return result
    }
    
    func getExpenseCellViewModel(section: Int, row: Int) -> HomeExpenseCellViewModel {
        return cellViewModels[section][row]
    }
    
    func createExpenseCellViewModel(expense: Expense) -> HomeExpenseCellViewModel {
        
        let payerUid = expense.payerInfo.getPayer()
        let user = CurrentManager.shared.getMemberInfo(uid: payerUid ?? "")
        
        return HomeExpenseCellViewModel(id: expense.id,
                                        type: ExpenseType(rawValue: expense.type)!,
                                        title: expense.desc,
                                        img: user?.photoURL,
                                        time: expense.time.toFullFormat,
                                        amount: expense.amount)
    }
    
    func fetchData() {
        
        isLoading = true
        
        FirestoreManager.shared.getExpenses { [weak self] result in
            switch result {
                
            case .success(let expenses):
                
                if expenses.isEmpty {
                    self?.expenses = [Expense]()
                } else {
                    self?.expenses = expenses
                }
                self?.processData()
                self?.createResultInfo()
                self?.isLoading = false

            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func processData() {
        
        var viewModels = [[HomeExpenseCellViewModel]]()
        
        var viewModelsSection = [HomeExpenseCellViewModel]()
        
        titleOfSections = [String]()
        
        if !expenses.isEmpty {
            
            titleOfSections.append(expenses[0].time.toSimpleFormat)
            
            var index = 0
            
            for expense in expenses {
                
                if titleOfSections[index] == expense.time.toSimpleFormat {
                    viewModelsSection.append(createExpenseCellViewModel(expense: expense))
                } else {
                    viewModels.append(viewModelsSection)
                    titleOfSections.append(expense.time.toSimpleFormat)
                    viewModelsSection = [HomeExpenseCellViewModel]()
                    viewModelsSection.append(createExpenseCellViewModel(expense: expense))
                    index += 1
                }
                
            }
            
            viewModels.append(viewModelsSection)
            
        }
        
        self.cellViewModels = viewModels
        
    }
    
    func getStatisticsCellViewModel() -> StatisticsCellViewModel {
        
        var viewModel = StatisticsCellViewModel(total: 0,
                                                count: 0,
                                                selfPay: 0,
                                                selfLend: 0,
                                                selfBorrow: 0)
        
        viewModel.count = expenses.count
        
        for expense in expenses {
            viewModel.total += expense.amount
        }
        
        for expense in expenses {
            
            guard let first = expense.payerInfo.amountDesc.first else { return viewModel }
            
            if first.member.id == CurrentManager.shared.user?.id {
                viewModel.selfPay += expense.amount
            }
        }
        
        for expense in expenses {
            
            guard let first = expense.payerInfo.amountDesc.first else {
                return viewModel
            }
            
            let selfID = CurrentManager.shared.user?.id
            
            if first.member.id == selfID {
            
                if SplitType(rawValue: expense.splitInfo.type) == SplitType.average {
                    
                    let pay = expense.amount / Double(expense.splitInfo.amountDesc.filter({$0.value != nil}).count)
                    
                    viewModel.selfLend += (expense.amount - pay)
                    
                } else if SplitType(rawValue: expense.splitInfo.type) == SplitType.percentage {
                    
                    guard let value = expense.splitInfo.amountDesc.filter({ $0.member.id == selfID}).first?.value
                    else { return viewModel}
                    
                    viewModel.selfLend += (expense.amount - (expense.amount * value / 100))
                    
                } else if SplitType(rawValue: expense.splitInfo.type) == SplitType.amount {
                    
                    guard let value = expense.splitInfo.amountDesc.filter({ $0.member.id == selfID}).first?.value
                    else { return viewModel}
                    
                    viewModel.selfLend += value
                }
            }
        }
        
        for expense in expenses {
            
            guard let payer = expense.payerInfo.amountDesc.first else { return viewModel }
            
            let selfID = CurrentManager.shared.user?.id
            
            if payer.member.id != selfID {
            
                if SplitType(rawValue: expense.splitInfo.type) == SplitType.average {
                    let eachPay = expense.amount / Double(expense.splitInfo.amountDesc.filter({$0.value != nil}).count)
                    viewModel.selfBorrow += (expense.amount - eachPay)
                    
                } else if SplitType(rawValue: expense.splitInfo.type) == SplitType.percentage {
                    guard let percentage = expense.splitInfo.amountDesc.filter({ $0.member.id == selfID}).first?.value
                    else { return viewModel}
                    let eachPay = (expense.amount * percentage / 100)
                    viewModel.selfBorrow += (expense.amount - eachPay)
                    
                } else if SplitType(rawValue: expense.splitInfo.type) == SplitType.amount {
                    guard let eachPay = expense.splitInfo.amountDesc.filter({ $0.member.id == selfID}).first?.value
                    else { return viewModel}
                    
                    viewModel.selfBorrow += eachPay
                }
                
            }
                
        }
        
        return viewModel
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
