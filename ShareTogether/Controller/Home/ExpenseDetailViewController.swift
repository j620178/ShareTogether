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
           tableView.registerWithNib(indentifer: ExpenseInfoTableViewCell.identifer, bundle: nil)
           tableView.registerWithNib(indentifer: ExepenseSplitTableViewCell.identifer, bundle: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "消費內容"
        
        let barItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editExpense))
        
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func editExpense() {
        guard let nextVC = UIStoryboard.expense.instantiateInitialViewController() as? STNavigationController,
            let addExpenseVC = nextVC.viewControllers[0] as? AddExpenseViewController else { return }

        addExpenseVC.expense = expense

        nextVC.modalPresentationStyle = .overCurrentContext

        self.present(nextVC, animated: true, completion: nil)
    }
    
}

extension ExpenseDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return expense?.splitInfo.amountDesc.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseInfoTableViewCell.identifer, for: indexPath)

            guard let expenseInfoCell = cell as? ExpenseInfoTableViewCell,
                let expense = expense,
                let group = CurrentInfoManager.shared.group,
                let payerUid = expense.payerInfo.amountDesc[0].member.id,
                let payer = CurrentInfoManager.shared.getMemberInfo(uid: payerUid) else { return cell }
            
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
            let cell = tableView.dequeueReusableCell(withIdentifier: ExepenseSplitTableViewCell.identifer, for: indexPath)

            guard let exepenseSplitCell = cell as? ExepenseSplitTableViewCell,
                let expense = expense,
                let spliterUid = expense.splitInfo.amountDesc[indexPath.row].member.id,
                let spliter = CurrentInfoManager.shared.getMemberInfo(uid: spliterUid)
            else { return cell }
                
            let splitAmount = expense.splitInfo.getAmount(amount: expense.amount,
                                                                index: indexPath.row)
                
            let cellViewModel = ExepenseSplitCellViewModel(userImageURL: spliter.photoURL,
                                                  userName: spliter.name + " 支付 \(splitAmount.toAmountText)")

            exepenseSplitCell.viewModel = cellViewModel

            return exepenseSplitCell
        }
    }
}
