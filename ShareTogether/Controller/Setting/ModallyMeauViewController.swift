//
//  ModallyMeauViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/10.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import SafariServices

class ModallyMeauViewController: STBaseViewController {
    
    let itemString = ["隱私權政策", "登出"] // "圖示順序", "通知", "已封存群組",
    
    weak var backgroundview: UIView?
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var meauViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBAction func clickCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewHeightConstraint.constant = CGFloat((itemString.count + 1) * 50)
        
        meauViewBottomConstraint.constant = -200
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.meauViewBottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        }
    }

}

extension ModallyMeauViewController: UITableViewDataSource {
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

extension ModallyMeauViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let url = URL(string: "https://www.privacypolicies.com/privacy/view/e9b6b5e82a15d74909eff1e0d8234312")
            let safariVC = SFSafariViewController(url: url!)
            safariVC.delegate = self
            self.show(safariVC, sender: nil)
            //self.present(safariVC, animated: true, completion: nil)
        } else {
            AuthManager.shared.signOut()
            CurrentInfoManager.shared.removeCurrentUser()
            CurrentInfoManager.shared.removeCurrentGroup()
            let nextVC = UIStoryboard.login.instantiateInitialViewController()!
            nextVC.modalPresentationStyle = .fullScreen
            present(nextVC, animated: true)
        }

    }
    
}

extension ModallyMeauViewController: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
