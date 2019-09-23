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
        }
    }
    
    weak var delegate: HomeViewControllerDelegate?
    
    var viewModel: HomeViewModel!
    
    var observation: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerWithNib(indentifer: StatisticsTableViewCell.identifer)
        
        observation = viewModel.observe(\.cellViewModels, options: [.initial, .new]) { (child, change) in
            self.tableView.reloadData()
        }
        
    }
    
}

// MARK: - Table view data source
extension StatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.identifer, for: indexPath)
        
        guard let statisticsCell = cell as? StatisticsTableViewCell else { return cell }
        
        statisticsCell.cellViewModel = viewModel.getStatisticsgetCellViewModel()
        
        return statisticsCell
    }
    
}

// MARK: - Table view delegate
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
        delegate?.tableViewDidScroll(viewController: self, offsetY: scrollView.contentOffset.y)
    }
    
}
