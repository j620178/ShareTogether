//
//  ExpenseTableViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func tableViewDidScroll(viewController: UIViewController, offsetY: CGFloat)
}

class ExpenseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    weak var delegate: HomeViewControllerDelegate?
    
    var viewModel: HomeViewModel!
    
    var observation: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerWithNib(indentifer: ExpenseTableViewCell.identifer)
        tableView.register(ExpenseFooterView.self,
                           forHeaderFooterViewReuseIdentifier: ExpenseFooterView.reuseIdentifier)

        observation = viewModel.observe(\.cellViewModels, options: [.initial, .new]) { (_, _) in
            self.tableView.reloadData()
        }
        
        viewModel.fectchData()

    }

}

// MARK: - Table view data source
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

        guard let recodeCell = cell as? ExpenseTableViewCell else { return cell }

        recodeCell.viewModel = viewModel.getExpenseCellViewModel(at: indexPath)

        return recodeCell

    }

}

// MARK: - Table view delegate
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
        delegate?.tableViewDidScroll(viewController: self, offsetY: scrollView.contentOffset.y)
    }
    
}
