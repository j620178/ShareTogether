//
//  InviteViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/10.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class InviteViewController: STBaseViewController {
    
    let viewModel = InviteViewModel()
    
    var showType = ShowType.new
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var inviteButton: UIButton! {
        didSet {
            inviteButton.backgroundColor = .STTintColor
            inviteButton.setTitleColor(.white, for: .normal)
        }
    }

    @IBAction func clickInviteButton(_ sender: UIButton) {
        
        switch showType {

        case .new:
            LKProgressHUD.showSuccess(text: "加入成功", view: self.view)
            viewModel.addInviteMembers()
        case .edit:
            LKProgressHUD.showSuccess(text: "邀請成功", view: self.view)
            viewModel.inviteMember()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchShowType()
        
        textField.becomeFirstResponder()
        
        viewModel.delegate = self
            
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.STDarkGray]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        inviteButton.layer.cornerRadius = inviteButton.frame.height / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if showType == .new, self.isMovingFromParent {
            for viewController in navigationController!.viewControllers {
                if let previousVC = viewController as? GroupViewController {
                    //previousVC.members += viewModel.getInviteMembers()
                    for inviteMember in viewModel.getInviteMembers() {
                        let result = previousVC.members.contains { memberInfo -> Bool in
                            return memberInfo.id == inviteMember.id
                        }
                        
                        if !result {
                            previousVC.members.append(inviteMember)
                        }
                    }
        
                }
            }
        }

    }
    
    func switchShowType() {
        if showType == .edit {
            inviteButton.setTitle("送出邀請", for: .normal)
        } else {
            inviteButton.setTitle("加入邀請名單", for: .normal)
        }
    }
    
}

extension InviteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        viewModel.searchUser(type: showType.rawValue, email: textField.text, phone: nil)
        
        return true
    }
    
}

extension InviteViewController: InviteViewModelDelegete {
    
    func updateView(text: String, imageURL: String?, isButtonHidden: Bool, isEnable: Bool = true) {
        
        userNameLabel.text = text
        
        if let imageURL = imageURL {
            userImageView.setUrlImage(imageURL)
            userImageView.layer.cornerRadius = userImageView.frame.height / 2
            userImageView.isHidden = false
            userNameLabel.textColor = .STDarkGray
        } else {
            userImageView.isHidden = true
            userNameLabel.textColor = .lightGray
        }
        
        if isEnable {
            inviteButton.setTitle("送出邀請", for: .normal)
        } else {
            inviteButton.setTitle("已加入群組", for: .normal)
        }
        
        inviteButton.isHidden = isButtonHidden
        inviteButton.isEnabled = isEnable
        
    }

}
