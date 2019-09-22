//
//  ResultTableViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
    
    let data = ["Kevin", "Nick", "Angle", "Daniel"]
    let data2 = ["3000", "200", "10000", "20330"]
    
    weak var delegate: TableViewControllerDelegate?
    
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerWithNib(indentifer: ResultTableViewCell.identifer)
    }

}

// MARK: - Table view data source
extension ResultTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifer, for: indexPath)
        
        guard let resultCell = cell as? ResultTableViewCell else { return cell }
        
        resultCell.uadateContent(leftUser: data[indexPath.row], rightUser: "Pony", amount: data2[indexPath.row])
        
        return resultCell
    }
    
}

// MARK: - Table view delegate
extension ResultTableViewController {
    
    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.tableViewDidScroll(viewController: self, offsetY: scrollView.contentOffset.y)
    }
    
}
