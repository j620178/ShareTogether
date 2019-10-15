//
//  ExpenseTableViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol HomeVCDelegate: AnyObject {

    func tableViewDidScroll(viewController: UIViewController, offsetY: CGFloat, contentSize: CGSize)
}

protocol ExpenseVCCoordinatorDelegate: AnyObject {
    
    func showDetailExpenseFrom(_ viewController: STBaseViewController, expense: Expense)
}

class ExpenseViewController: STBaseViewController {

    weak var coordinator: ExpenseVCCoordinatorDelegate?
    
    weak var delegate: HomeVCDelegate?
    
    var viewModel: HomeViewModel?
    
    var observation: NSKeyValueObservation!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            
            tableView.delegate = self
            
            tableView.registerWithNib(identifier: ExpenseTableViewCell.identifier)
            
            tableView.register(ExpenseFooterView.self,
                               forHeaderFooterViewReuseIdentifier: ExpenseFooterView.reuseIdentifier)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.fetchData()
        
        observation = viewModel?.observe(\.cellViewModels, options: [.initial, .new]) { [weak self] (_, _) in
            self?.tableView.reloadData()
        }
    }
}

extension ExpenseViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        viewModel?.numberOfSections == 0 ? (tableView.alpha = 0) : (tableView.alpha = 1)
        
        return viewModel?.numberOfSections ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return viewModel?.titleOfSections(section: section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.numberOfCells(section: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.identifier,
                                                 for: indexPath)

        guard let expenseCell = cell as? ExpenseTableViewCell else { return cell }

        expenseCell.viewModel = viewModel?.getExpenseCellViewModel(section: indexPath.section,
                                                                   row: indexPath.row)

        return expenseCell
    }
}

extension ExpenseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        
        let header = view as? UITableViewHeaderFooterView
        
        header?.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        delegate?.tableViewDidScroll(viewController: self,
                                     offsetY: scrollView.contentOffset.y,
                                     contentSize: scrollView.contentSize)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let expense = viewModel?.getExpense(section: indexPath.section, row: indexPath.row)
        
        else { return }
        
        coordinator?.showDetailExpenseFrom(self, expense: expense)
    }
}
