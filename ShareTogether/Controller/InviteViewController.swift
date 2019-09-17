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
            viewModel.addInviteMembers()
        case .edit:
            viewModel.inviteMember()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchShowType()
        
        textField.becomeFirstResponder()
        
        viewModel.delegate = self
    
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.STDarkGray]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        inviteButton.layer.cornerRadius = inviteButton.frame.height / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if showType == .new, self.isMovingFromParent {
            for viewController in navigationController!.viewControllers {
                if let previousVC = viewController as? AddGroupViewController {
                    previousVC.memberData += viewModel.getInviteMembers()
                }
            }
        }

    }
    
    func switchShowType() {
        if showType == .edit {
            let rightItem = UIBarButtonItem(title: "邀請", style: .plain, target: self, action: nil)
            navigationItem.rightBarButtonItem = rightItem
        }
    }
    
}

extension InviteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        viewModel.searchUser(email: textField.text, phone: nil)
        
        return true
    }
    
}

extension InviteViewController: InviteViewModelDelegete {
    
    func updateView(text: String, imageURL: String?, isButtonHidden: Bool) {
        
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
        
        inviteButton.isHidden = isButtonHidden
        
    }

}
