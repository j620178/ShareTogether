//
//  AddExpenseViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/11.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class AddExpenseViewModel {
    
    func addExpense(expense: Expense) {
            
            FirestoreManager.shared.updateExpense(expense: expense) { [weak self] result in
                
                switch result {

                case .success:
                    
                    for member in CurrentManager.shared.availableMembersWithoutSelf {
                        
                        FirestoreManager.shared.addActivity(type: .editExpense, targetMember: member, expense: expense)
                        
                    }
                    
                    LKProgressHUD.dismiss()
                    
//                    self?.dismiss(animated: true, completion: nil)
//
//                    if let previousVC = self?.navigationController?.presentingViewController
//                        as? STNavigationController {
//
//                        previousVC.popViewController(animated: true)
//
//                    }
                    
                case .failure(let error):
                    
                    LKProgressHUD.showFailure(text: error.localizedDescription)
                    
                }
            }
            

    }
    
    func updateExpense(expense: Expense) {
        
        FirestoreManager.shared.addExpense(expense: expense) { [weak self] result in
            
            switch result {

            case .success:
                
                for member in CurrentManager.shared.availableMembersWithoutSelf {
                    
                    FirestoreManager.shared.addActivity(type: .addExpense, targetMember: member, expense: expense)
                    
                }
                
                LKProgressHUD.dismiss()
                
                //self?.dismiss(animated: true, completion: nil)
                
            case .failure(let error):
                
                LKProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
        
    }
    
}
