//
//  ResultTableViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
    
    weak var delegate: TableViewControllerDelegate?
    
    var members = [MemberInfo]()
    
    var availableMembers: [MemberInfo] {
        var availableMembers = [MemberInfo]()
        
        for member in members {
            if MemberStatusType.init(rawValue: member.status) == MemberStatusType.quit ||
                MemberStatusType.init(rawValue: member.status) == MemberStatusType.archive {
            } else {
                availableMembers.append(member)
            }
        }
        
        return availableMembers
    }
    
    var viewModel: HomeViewModel!
    
    var observation: NSKeyValueObservation!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerWithNib(indentifer: ResultTableViewCell.identifer)
        
        fetchMember()
        
        observation = viewModel.observe(\.cellViewModels, options: [.initial, .old, .new, .prior]) { [weak self] (child, change) in
            self?.viewModel.createResultInfo()
            self?.tableView.reloadData()
        }
        
    }

    func fetchMember() {
        FirestoreManager.shared.getMembers { [weak self] result in
            switch result {
                
            case .success(var members):
                var index = 0
                for member in members {
                    
                    if member.id == UserInfoManager.shaered.currentUserInfo?.id {
                        members.remove(at: index)
                        self?.members = members
                        break
                    }
                    
                    index += 1

                }

            case .failure:
                print("error")
            }
        }
        
    }
}

// MARK: - Table view data source
extension ResultTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(availableMembers.count)
        return availableMembers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifer, for: indexPath)
        
        guard let resultCell = cell as? ResultTableViewCell,
            let currentUserInfo = UserInfoManager.shaered.currentUserInfo,
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
