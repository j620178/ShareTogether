//
//  SearchViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/23.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import MapKit

class SearchViewModel {
    
    var expenses = [Expense]()
    
    var backupExpenses = [Expense]()
    
    var selectedExpense: Expense? {
        didSet {
            guard let selectedExpense = selectedExpense else { return }
            reloadInfoWindowHandler?(selectedExpense.desc)
        }
    }
    
    var annotations = [STMKPointAnnotation]() {
        willSet {
            removeAnnotationHandler?()
        }
        didSet {
            showAnnotationHandler?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingHandler?()
        }
    }
    
    var removeAnnotationHandler: (() -> Void)?
    
    var showAnnotationHandler: (() -> Void)?
    
    var updateLoadingHandler: (() -> Void)?
    
    var reloadInfoWindowHandler: ((String) -> Void)?
    
    func fectchData() {
        isLoading = true
        FirestoreManager.shared.getExpenses { [weak self] result in
            self?.isLoading = false
            
            switch result {
                
            case .success(let expenses):
                //refator
                self?.expenses = expenses
                self?.backupExpenses = expenses
                self?.processData()

            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func processData() {
        var annotations = [STMKPointAnnotation]()
        for index in expenses.indices {
            let annotation = STMKPointAnnotation()
            annotation.title = expenses[index].desc
            annotation.identifier = index
            annotation.coordinate = CLLocationCoordinate2D(latitude: expenses[index].position.latitude,
                                                           longitude: expenses[index].position.longitude)
            annotations.append(annotation)
        }
    
        self.annotations = annotations
    }

}

extension SearchViewModel {
    func userPressed(at index: Int) {
        self.selectedExpense = self.expenses[index]
    }
    
    func getSelectedExpenseViewModel() -> ExpenseInfoCellViewModel? {
        guard let selectedExpense = selectedExpense ,
            let group = CurrentInfoManager.shared.group,
            let payerUid = selectedExpense.payerInfo.amountDesc[0].member.id,
            let payer = CurrentInfoManager.shared.getMemberInfo(uid: payerUid) else { return nil }
        return ExpenseInfoCellViewModel(desc: selectedExpense.desc,
                                        amount: selectedExpense.amount.toAmountText,
                                        amountType: ExpenseType(rawValue: selectedExpense.type) ?? .null,
                                        groupName: group.name,
                                        userImageURL: payer.photoURL,
                                        payer: "由 \(payer.name) 支付 \(selectedExpense.amount.toAmountText)",
                                        time: selectedExpense.time.toFullFormat)
    }
    
    func getSelectedSplitViewModel(at indexPath: IndexPath) -> ExepenseSplitCellViewModel? {
        guard let selectedExpense = selectedExpense ,
            let spliterUid = selectedExpense.splitInfo.amountDesc[indexPath.row].member.id,
            let spliter = CurrentInfoManager.shared.getMemberInfo(uid: spliterUid) else { return nil }
        
        let splitAmount = selectedExpense.splitInfo.getAmount(amount: selectedExpense.amount,
                                                        index: indexPath.row)
        
        return ExepenseSplitCellViewModel(userImageURL: spliter.photoURL,
                                          userName: spliter.name + " 支付 \(splitAmount.toAmountText)")
    }
    
    func searchExpense(keyWord text: String) {
        isLoading = true
        
        backupExpenses = expenses
        
        var tempExpenses = [Expense]()
        
        expenses.forEach { expense in
            if expense.desc.contains(text) {
                tempExpenses.append(expense)
            }
        }
        
        expenses = tempExpenses
        processData()
        isLoading = false
        
    }
    
    func resetExpenses() {
        expenses = backupExpenses
        processData()
    }
    
}

class STMKPointAnnotation: MKPointAnnotation {
    var identifier: Int = 0
}
