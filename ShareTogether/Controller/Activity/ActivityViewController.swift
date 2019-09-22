//
//  SearchViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import MapKit

class ActivityViewController: STBaseViewController {
    
    var viewModel = ActivityViewModel()
            
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.registerWithNib(indentifer: ActivityTableViewCell.identifer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fectchData()
        viewModel.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }

}

extension ActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifer, for: indexPath)
        
        guard let activityCell = cell as? ActivityTableViewCell else { return cell }
        
        activityCell.cellViewModel = viewModel.getViewModelAt(indexPath)
        
        return activityCell
    }
    
}
