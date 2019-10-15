//
//  InviteViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/10.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol InviteVCCoordinatorDelegate: AnyObject {
    
    func didFinishInviteFrom(_ viewController: STBaseViewController, members: [MemberInfo]?)
}

class InviteViewController: STBaseViewController {
    
    weak var coordinator: InviteVCCoordinatorDelegate?
    
    var viewModel: InviteViewModel?
    
    var type = GroupType.add
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupMVBinding()
        
        textField.becomeFirstResponder()
            
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.STDarkGray]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        inviteButton.layer.cornerRadius = inviteButton.frame.height / 2
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if type == .add {
            
            coordinator?.didFinishInviteFrom(self, members: viewModel?.inviteMemberData)
        }
    }
    
    func setupMVBinding() {
        
        viewModel?.updateButtonStatus = { [weak self] (text, imageURL, isHidden, isEnabled) in
            
            self?.userNameLabel.text = text
            
            if let imageURL = imageURL {
                
                self?.userImageView.setUrlImage(imageURL)
                
                self?.userImageView.isHidden = false
                
                self?.userNameLabel.textColor = .STDarkGray
                
            } else {
                
                self?.userImageView.isHidden = true
                
                self?.userNameLabel.textColor = .lightGray
                
            }
            
            self?.inviteButton.isHidden = isHidden
            
            self?.inviteButton.isEnabled = isEnabled
            
            if isEnabled {
                
                self?.inviteButton.setTitle(self?.type == .add ? "加入邀請清單" : "發送邀請", for: .normal)
                
            } else {
                
                self?.inviteButton.setTitle("已在群組名單", for: .normal)
            }
        }
    }

    @IBAction func clickInviteButton(_ sender: UIButton) {
        
        switch type {

        case .add:
            
            LKProgressHUD.showSuccess(text: "加入成功", view: self.view)
            
            viewModel?.addInviteMembers()
            
        case .edit:
            
            LKProgressHUD.showSuccess(text: "邀請成功", view: self.view)
            
            viewModel?.inviteMember()
        }
    }
}

extension InviteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        viewModel?.searchUser(type: type.rawValue, email: textField.text, phone: nil)
        
        return true
    }
}
