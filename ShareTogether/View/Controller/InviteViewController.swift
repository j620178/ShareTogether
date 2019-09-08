//
//  InviteViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/10.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "成員邀請"
        
        textField.becomeFirstResponder()
    }

}
