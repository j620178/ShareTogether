//
//  StatisticsTableViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerWithNib(identifier: StatisticsTableViewCell.identifier)
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
        
    }
    
}

extension StatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfSections == 0 ? (tableView.alpha = 0) : (tableView.alpha = 1)
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.identifier, for: indexPath)
        
        guard let statisticsCell = cell as? StatisticsTableViewCell else { return cell }
        
        statisticsCell.cellViewModel = viewModel.getStatisticsCellViewModel()
        
        return statisticsCell
    }
    
}

extension StatisticsViewController: UITableViewDelegate {
    
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
    
}
