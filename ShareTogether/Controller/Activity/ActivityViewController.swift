//
//  SearchViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import MapKit

enum ActivityType: Int {
    case invite = 0
    case addExpense = 1
    case editExpense = 2
    case addNote = 3
    case acceptMember = 4
    case rejectMember = 5
}

enum ActivityStatus: Int {
    case new = 0
    case loaded = 1
    case readed = 2
}

class ActivityViewController: STBaseViewController {
    
    var viewModel = ActivityViewModel()
            
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerWithNib(identifier: ActivityTableViewCell.identifier)
            tableView.registerWithNib(identifier: ActivityInfoTableViewCell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        navigationController?.tabBarItem.badgeValue = nil
        
        viewModel.fectchData()
        viewModel.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(upadateCurrentGroup),
                                               name: NSNotification.Name(rawValue: "CurrentGroup"),
                                               object: nil)

        upadateCurrentGroup()
    }

    @objc func upadateCurrentGroup() {
        viewModel.fectchData()
    }

}

extension ActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfCells == 0 {
            tableView.alpha = 0
        } else {
            tableView.alpha = 1
        }
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.activities[indexPath.row].type == ActivityType.invite.rawValue ||
            viewModel.activities[indexPath.row].type == ActivityType.acceptMember.rawValue ||
            viewModel.activities[indexPath.row].type == ActivityType.rejectMember.rawValue {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier, for: indexPath)
            
            guard let activityCell = cell as? ActivityTableViewCell else { return cell }
            
            activityCell.cellViewModel = viewModel.getViewModelAt(indexPath)
            
            activityCell.clickCellHandler = { [weak self] cell in
                
                guard let indexPath = tableView.indexPath(for: cell) else { return }
                
                self?.viewModel.addGroupButton(indexPath: indexPath)
            }
            
            return activityCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityInfoTableViewCell.identifier,
                                                     for: indexPath)
            
            guard let activityCell = cell as? ActivityInfoTableViewCell else { return cell }
            
            activityCell.cellViewModel = viewModel.getViewModelAt(indexPath)
            
            return activityCell
        }

    }
    
}

extension ActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
