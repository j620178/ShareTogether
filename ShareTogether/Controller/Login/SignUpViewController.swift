//
//  SignUpViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/8.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol SignUpViewCoordinatorDelegate: AnyObject {
    
    func didSignUpFrom(_ viewController: UIViewController)
    
    func showPrivateInfoWithFrom(_ viewController: UIViewController)
}

class SignUpViewController: STBaseViewController {
    
    weak var coordinator: SignUpViewCoordinatorDelegate?
    
    var viewModel: SignUpViewModel?
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        
        setupVMBinding()
        
        userNameTextField.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        userNameTextField.layer.cornerRadius = emailTextField.frame.height / 4
        
        emailTextField.layer.cornerRadius = passwordTextField.frame.height / 4
        
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 4
        
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 4
    }
    
    func setupView() {
        
        title = "註冊帳號資訊"

        userNameTextField.addLeftSpace()
        
        emailTextField.addLeftSpace()
        
        passwordTextField.addLeftSpace()

        userNameTextField.textColor = .STDarkGray
        
        emailTextField.textColor = .STDarkGray
        
        passwordTextField.textColor = .STDarkGray

        signUpButton.backgroundColor = .STTintColor
        
        signUpButton.setTitleColor(.white, for: .normal)
    }
    
     func setupVMBinding() {
       
        viewModel?.loadingHandler = { isLoading in
            
            switch isLoading {
                
            case true:
                
                LKProgressHUD.showLoading()
                
            case false:
                
                LKProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func privateInfo(_ sender: UIButton) {
        
        coordinator?.showPrivateInfoWithFrom(self)
    }
    
    @IBAction func clickSignUpButton(_ sender: UIButton) {
        
        guard let userName = userNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }

        viewModel?.signUp(userName: userName,
                          email: email,
                          password: password,
                          completion: { [weak self] result in
                            
                            guard let strongSelf = self else { return }
                            
                            switch result {
                                
                            case .success(let text):
                                
                                LKProgressHUD.showSuccess(text: text, view: strongSelf.view)
                                
                                strongSelf.coordinator?.didSignUpFrom(strongSelf)
                                
                            case .failure(let error):
                                
                                switch error {

                                case .empty:
                                  
                                    LKProgressHUD.showFailure(text: "未完整填寫註冊資訊", view: strongSelf.view)
                                  
                                case .failure:
                                  
                                    LKProgressHUD.showFailure(text: "註冊失敗", view: strongSelf.view)
                                }
                            }
        })
    }
}
