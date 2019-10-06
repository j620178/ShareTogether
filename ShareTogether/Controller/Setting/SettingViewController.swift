//
//  SettingViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/10.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol SettingVCCoordinatorDelegate: AnyObject {
    
    func showPrivateInfoFrom(_ viewController: STBaseViewController)
    
    func didLogoutFrom(_ viewController: STBaseViewController)
    
    func didCancelFrom(_ viewController: STBaseViewController)
}

class SettingViewController: STBaseViewController {
    
    weak var coordinator: SettingVCCoordinatorDelegate?
    
    let itemString = ["隱私權政策", "登出"] // "圖示順序", "通知", "已封存群組",
    
    weak var backgroundview: UIView?
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var settingViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewHeightConstraint.constant = CGFloat((itemString.count + 1) * 50)
        
        settingViewBottomConstraint.constant = -200
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            
            self?.settingViewBottomConstraint.constant = 0
            
            self?.view.layoutIfNeeded()
        }
    }
    
    @IBAction func clickCancelButton(_ sender: UIButton) {
        
        coordinator?.didCancelFrom(self)
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        
        cell.textLabel?.text = itemString[indexPath.row]
        
        if indexPath.row == 0 {
            
            cell.imageView?.image = .getIcon(code: "ios-book", color: .STTintColor, size: 40)
            
        } else {
            
            cell.imageView?.image = .getIcon(code: "ios-log-out", color: .STTintColor, size: 40)
            
        }

        return cell
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            coordinator?.showPrivateInfoFrom(self)

        } else {
            
            coordinator?.didLogoutFrom(self)
            
        }
    }
}
