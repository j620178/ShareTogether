//
//  NotebookTableViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class NotebookViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    let data = ["Pony", "Kevin", "Nick", "Angel", "Daniel"]
    let data2 = ["Me", "恩～～～～", "我是天才!!!!", "你長大就知道了🚬", "等等就去買電池"]
    
    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerWithNib(indentifer: NotebookTableViewCell.identifer)
        tableView.registerWithNib(indentifer: AddNotebookTableViewCell.identifer)
    }

}

// MARK: - Table view data source
extension NotebookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddNotebookTableViewCell.identifer, for: indexPath)
            guard let addNotebookCell = cell as? AddNotebookTableViewCell else { return cell }
            return addNotebookCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NotebookTableViewCell.identifer, for: indexPath)
            guard let notebookCell = cell as? NotebookTableViewCell else { return cell }
            notebookCell.userNameLabel.text = data[indexPath.row]
            notebookCell.contentLabel.text = data2[indexPath.row]
            notebookCell.timeLabel.text = "2019/7/2"
            return notebookCell
        }
        
    }
    
}

// MARK: - Table view delegate
extension NotebookViewController: UITableViewDelegate {
    
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
