//
//  AddGroupViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class AddGroupViewController: STBaseViewController {

    @IBOutlet weak var addGroupLabel: UILabel!
    
    @IBOutlet weak var groupNameView: UIView!
    
    @IBOutlet weak var groupMemberView: UIView!
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textfieldTopConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var textfieldBottomConstaint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupNameView.layer.cornerRadius = 20.0
        groupNameView.layer.maskedCorners = [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner]
        
        groupMemberView.layer.cornerRadius = 20.0
        groupMemberView.layer.maskedCorners = [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner]
        
        groupNameTextField.borderStyle = .none
        groupNameTextField.layer.cornerRadius = 10.0
        groupNameTextField.clipsToBounds = true
        groupNameTextField.becomeFirstResponder()
        groupNameTextField.leftViewMode = .always
        groupNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(checkAction))
        
        let gesture2 = UISwipeGestureRecognizer(target: self, action: #selector(checkAction))
        gesture2.direction = .up
            //UIPanGestureRecognizer

        self.groupMemberView.addGestureRecognizer(gesture)
        self.groupMemberView.addGestureRecognizer(gesture2)
    }
    
    @objc func checkAction(_ sender: UITapGestureRecognizer) {
        groupNameTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.labelTopConstraint.constant = -50
            self?.textfieldTopConstaint.constant = 20
            self?.textfieldBottomConstaint.constant = 20
            self?.addGroupLabel.alpha = 0
            self?.view.layoutIfNeeded()
        }

    }

}
