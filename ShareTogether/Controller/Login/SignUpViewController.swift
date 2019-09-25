//
//  SignUpViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/8.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import SafariServices

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func praviteInfo(_ sender: UIButton) {
        
        let url = URL(string: "https://www.privacypolicies.com/privacy/view/e9b6b5e82a15d74909eff1e0d8234312")
        let safariVC = SFSafariViewController(url: url!)
        safariVC.delegate = self
        self.show(safariVC, sender: nil)
        
    }
    
    @IBAction func clickSignUpButton(_ sender: UIButton) {
        if userNameTextField.text == "" ||
            emailTextField.text == "" ||
            passwordTextField.text == "" {
            LKProgressHUD.showFailure(text: "請輸入完整資訊", view: self.view)
        } else {
            LKProgressHUD.showLoading(view: self.view)
            
            guard let userName = userNameTextField.text, let email = emailTextField.text else { return }
            
            AuthManager.shared.createNewUser(email: emailTextField.text!,
                                              password: passwordTextField.text!) { uid in
                                                FirestoreManager.shared.insertNewUser(userInfo: UserInfo(id: uid,
                                                                                                         name: userName,
                                                                                                         email: email,
                                                                                                         phone: nil,
                                                                                                         photoURL: "",
                                                                                                         groups: nil)) { result in
                                                    switch result {
                                                        
                                                    case .success:
                                                        LKProgressHUD.dismiss()
                                                    case .failure:
                                                        print("錯誤LKProgressHUD")
                                                    }
                                                }
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

extension SignUpViewController: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
