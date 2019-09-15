//
//  SignUpViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/8.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func clickSignUpButton(_ sender: UIButton) {
        if userNameTextField.text == "" ||
            emailTextField.text == "" ||
            passwordTextField.text == "" {
            print("請輸入完整資訊")
        } else {
            AuthManager.shared.createNewUser(email: emailTextField.text!,
                                              password: passwordTextField.text!) { text in
                print(text)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "註冊帳號資訊"
        
        userNameTextField.addLeftSpace()
        emailTextField.addLeftSpace()
        passwordTextField.addLeftSpace()
        
        userNameTextField.textColor = .STDarkGray
        emailTextField.textColor = .STDarkGray
        passwordTextField.textColor = .STDarkGray
        
        signUpButton.backgroundColor = .STTintColor
        signUpButton.setTitleColor(.white, for: .normal)
        
        userNameTextField.becomeFirstResponder()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        userNameTextField.layer.cornerRadius = emailTextField.frame.height / 4
        emailTextField.layer.cornerRadius = passwordTextField.frame.height / 4
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 4
        
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 4
        
    }

}
