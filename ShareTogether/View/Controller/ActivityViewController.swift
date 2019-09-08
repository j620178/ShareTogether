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
    
    @IBOutlet weak var goSearchButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.registerWithNib(indentifer: ActivityTableViewCell.identifer, bundle: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        goSearchButton.layer.cornerRadius = goSearchButton.frame.height / 2
        goSearchButton.clipsToBounds = true
        goSearchButton.backgroundColor = .backgroundLightGray
        goSearchButton.setImage(.getIcon(code: "ios-search", color: .darkGray, size: 20), for: .normal)
    }

}

extension ActivityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifer, for: indexPath)
        
        guard let activityCell = cell as? ActivityTableViewCell else { return cell }
        
        return activityCell
    }
    
}
