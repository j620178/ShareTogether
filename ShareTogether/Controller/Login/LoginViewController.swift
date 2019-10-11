//
//  LoginViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/8.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import AuthenticationServices

protocol LoginViewCoordinatorDelegate: AnyObject {
    
    func didLoginFrom(_ viewController: UIViewController)
        
    func showGoogleSignInFrom(_ viewController: UIViewController,
                              completion: @escaping CoordinatorResult)
    
    func showFacebookSignInFrom(_ viewController: UIViewController,
                                completion: @escaping CoordinatorResult)
    
    func showAppleSignInFrom(_ viewController: UIViewController,
                             completion: @escaping CoordinatorResult)
    
    func showSignUpFrom(_ viewController: UIViewController)
}

class LoginViewController: STBaseViewController {
    
    //override var isHideNavigationBar: Bool { return true }
    
    weak var coordinator: LoginViewCoordinatorDelegate?
        
    var viewModel: LoginViewModel?
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var googleLoginButton: UIButton!

    @IBOutlet weak var facebookLoginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var appleSignInButton: ASAuthorizationAppleIDButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupVMBinding()
        
        appleSignInButton.addTarget(self, action: #selector(clickAppleSignInButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emailTextField.layer.cornerRadius = emailTextField.frame.height / 4
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 4
        
        loginButton.layer.cornerRadius = loginButton.frame.height / 4
        googleLoginButton.layer.cornerRadius = googleLoginButton.frame.height / 4
        facebookLoginButton.layer.cornerRadius = facebookLoginButton.frame.height / 4
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 4
        appleSignInButton.cornerRadius = appleSignInButton.frame.height / 4
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
    
    func setupView() {
        emailTextField.addLeftSpace()
        emailTextField.textColor = .STDarkGray
        passwordTextField.addLeftSpace()
        passwordTextField.textColor = .STDarkGray
        
        loginButton.backgroundColor = .STTintColor
        loginButton.setTitleColor(.white, for: .normal)
        
        googleLoginButton.setImage(.getIcon(code: "logo-google", color: .STTintColor, size: 20), for: .normal)
        googleLoginButton.layer.borderColor = UIColor.STTintColor.cgColor
        googleLoginButton.layer.borderWidth = 1.0
        
        facebookLoginButton.setImage(.getIcon(code: "logo-facebook", color: .STTintColor, size: 20), for: .normal)
        facebookLoginButton.layer.borderColor = UIColor.STTintColor.cgColor
        facebookLoginButton.layer.borderWidth = 1.0
        
        signUpButton.setTitleColor(.STDarkGray, for: .normal)
    }
    
    func checkRegister(result: Result<UserInfo, Error>) {
        
        switch result {
            
        case .success(let authUserInfo):

            self.viewModel?.checkRegister(authUserInfo: authUserInfo,
                                          completion: { [weak self] result in
                                            self?.checkLogin(result: result)
            })

        case .failure:
            print("2")
        }
    }
    
    func checkLogin(result: Result<String, LoginError>) {
        
        switch result {
            
        case .success(let text):
            
            LKProgressHUD.showFailure(text: text, view: self.view)
            
            coordinator?.didLoginFrom(self)
            
        case .failure(let error):
            
            switch error {
  
            case .empty:
                
                LKProgressHUD.showFailure(text: "未完整填寫登入資訊", view: self.view)
                
            case .failure:
                
                LKProgressHUD.showFailure(text: "登入失敗", view: self.view)
            }
        }
    }

    @IBAction func clickLoginButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        viewModel?.loginWithEmail(email: email, password: password, completion: { [weak self] result in
            
            self?.checkLogin(result: result)

        })
    }

    @objc func clickAppleSignInButton() {
        
         coordinator?.showAppleSignInFrom(self, completion: { [weak self] result in
            
            self?.checkRegister(result: result)
         })
    }
    
    @IBAction func clickOAuthLoginButton(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            coordinator?.showGoogleSignInFrom(self, completion: { [weak self] result in

               self?.checkRegister(result: result)
                
            })
     
        } else if sender.tag == 2 {
            
            coordinator?.showFacebookSignInFrom(self, completion: { [weak self] result in

                self?.checkRegister(result: result)
            })
        }
    }
    
    @IBAction func clickSignUpButton(_ sender: UIButton) {
        
        coordinator?.showSignUpFrom(self)
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential
        else { return }
        
        let credentialUser = CredentialUser(credentials: credentials)
        
        let userInfo = UserInfo(id: credentialUser.id,
                                name: credentialUser.lastName + credentialUser.firstName,
                                email: credentialUser.email,
                                phone: nil,
                                photoURL: nil,
                                groups: nil)

        viewModel?.checkRegister(authUserInfo: userInfo, completion: { [weak self] result in
            
            self?.checkLogin(result: result)
            
        })
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return view.window!
    }
}
