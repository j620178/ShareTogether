//
//  ExpenseDetailViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/30.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ExpenseDetailViewController: STBaseViewController {
    
    var expense: Expense?

    @IBOutlet weak var tableView: UITableView! {
        didSet {
           tableView.dataSource = self
           tableView.registerWithNib(identifier: ExpenseInfoTableViewCell.identifier, bundle: nil)
           tableView.registerWithNib(identifier: ExpenseSplitTableViewCell.identifier, bundle: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "消費內容"
        
        let barItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(editExpense))
        
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func editExpense() {
        
        if isEditAvailable() {
            
            guard let nextVC = UIStoryboard.expense.instantiateInitialViewController() as? STNavigationController,
                let addExpenseVC = nextVC.viewControllers[0] as? AddExpenseViewController else { return }

            addExpenseVC.expense = expense

            nextVC.modalPresentationStyle = .overCurrentContext

            self.present(nextVC, animated: true, completion: nil)
            
        } else {
            
            LKProgressHUD.showFailure(text: "本筆消費包含已退出成員，無法修改。請將其加回，即可進行修改。",
                                      view: self.view)
        }
    }
    
    func isEditAvailable() -> Bool {
        
        guard let expense = expense,
            let payerUid = expense.payerInfo.amountDesc.first?.member.id
        else { return false }
        
        let availableMembers = CurrentManager.shared.availableMembers
        
        let payerResult = availableMembers.filter { member -> Bool in
            
            payerUid == member.id
        }
        
        if payerResult.isEmpty {
            
            return false
        }

        for spliter in expense.splitInfo.amountDesc {
            
            let spliterResult = availableMembers.filter { member -> Bool in
                
                spliter.member.id == member.id
            }
            
            if spliterResult.isEmpty {
                
                return false
            }
        }
        
        return true
        
    }
    
}

extension ExpenseDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : (expense?.splitInfo.amountDesc.count ?? 0)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseInfoTableViewCell.identifier,
                                                     for: indexPath)
            
            guard let expenseInfoCell = cell as? ExpenseInfoTableViewCell,
                let expense = expense,
                let group = CurrentManager.shared.group,
                let payerUid = expense.payerInfo.getPayer(),
                let payer = CurrentManager.shared.getMemberInfo(uid: payerUid)
            else { return cell }
            
            let cellViewModel = ExpenseInfoCellViewModel(desc: expense.desc,
                                            amount: expense.amount.toAmountText,
                                            amountType: ExpenseType(rawValue: expense.type) ?? .null,
                                            groupName: group.name,
                                            userImageURL: payer.photoURL,
                                            payer: "由 \(payer.name) 支付 \(expense.amount.toAmountText)",
                                            time: expense.time.toFullFormat)
            
            expenseInfoCell.viewModel = cellViewModel

            return expenseInfoCell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseSplitTableViewCell.identifier,
                                                     for: indexPath)

            guard let expenseSplitCell = cell as? ExpenseSplitTableViewCell,
                let expense = expense,
                let spliterUid = expense.splitInfo.amountDesc[indexPath.row].member.id,
                let spliter = CurrentManager.shared.getMemberInfo(uid: spliterUid)
            else { return cell }
                
            let splitAmount = expense.splitInfo.getAmount(amount: expense.amount,
                                                                index: indexPath.row)
                
            let cellViewModel = ExpenseSplitCellViewModel(userImageURL: spliter.photoURL,
                                                  userName: spliter.name + " 支付 \(splitAmount.toAmountText)")

            expenseSplitCell.viewModel = cellViewModel

            return expenseSplitCell
        }
    }
}
