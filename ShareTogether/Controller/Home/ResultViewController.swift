//
//  ResultTableViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var availableMembers: [MemberInfo] {
        return CurrentInfoManager.shared.availableMembersWithoutSelf
    }
    
    var viewModel: HomeViewModel!
    
    weak var delegate: HomeViewControllerDelegate?
    
    var observation: NSKeyValueObservation!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerWithNib(indentifer: ResultTableViewCell.identifer)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observation = viewModel.observe(\.cellViewModels, options: [.initial, .new]) { [weak self] (_, _) in
            self?.viewModel.createResultInfo()
            self?.tableView.reloadData()
        }
        
    }

}

extension ResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        availableMembers.count == 0 ? (tableView.alpha = 0) : (tableView.alpha = 1)
        return availableMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifer, for: indexPath)
        
        guard let resultCell = cell as? ResultTableViewCell,
            let currentUserInfo = CurrentInfoManager.shared.user,
            let amount = viewModel.getResultInfo(uid: availableMembers[indexPath.row].id)
        else { return cell }
        
        resultCell.setupContent(leftUserImageURL: availableMembers[indexPath.row].photoURL,
                                leftUserName: availableMembers[indexPath.row].name,
                                rightUserImageURL: currentUserInfo.photoURL,
                                rightUserName: currentUserInfo.name,
                                amount: "\(amount)")
        
        return resultCell
    }
    
}

extension ResultViewController: UITableViewDelegate {
    
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
