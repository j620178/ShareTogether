//
//  ExpenseTableViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func tableViewDidScroll(viewController: UIViewController, offsetY: CGFloat, contentSize: CGSize)
}

class ExpenseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerWithNib(indentifer: ExpenseTableViewCell.identifer)
            tableView.register(ExpenseFooterView.self,
                               forHeaderFooterViewReuseIdentifier: ExpenseFooterView.reuseIdentifier)
        }
    }
    
    weak var delegate: HomeViewControllerDelegate?
    
    var viewModel: HomeViewModel!
    
    var observation: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observation = viewModel.observe(\.cellViewModels, options: [.initial, .new]) { (_, _) in
            self.tableView.reloadData()
        }
        
        viewModel.fectchData()
    }

}

extension ExpenseViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        viewModel.numberOfSections == 0 ? (tableView.alpha = 0) : (tableView.alpha = 1)
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return viewModel.titleOfSections(section: section)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfCells(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.identifer, for: indexPath)

        guard let expenseCell = cell as? ExpenseTableViewCell else { return cell }

        expenseCell.viewModel = viewModel.getExpenseCellViewModel(at: indexPath)

        return expenseCell
    }

}

extension ExpenseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
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
        
        guard let nextVC = UIStoryboard.expense.instantiateInitialViewController() as? STNavigationController,
            let addExpenseVC = nextVC.viewControllers[0] as? AddExpenseViewController else { return }
        
        addExpenseVC.expense = viewModel.getExpense(at: indexPath)
        
        nextVC.modalPresentationStyle = .overFullScreen
        
        self.present(nextVC, animated: true, completion: nil)
        
    }
    
}
