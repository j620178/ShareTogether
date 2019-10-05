//
//  LoginViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/8.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: STBaseViewController {
    
    override var isHideNavigationBar: Bool { return true }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var googleLoginButton: UIButton!

    @IBOutlet weak var facebookLoginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var appleSignInButton: ASAuthorizationAppleIDButton!
    
    var coordinatorDelegate: LoginCoordinatorDelegate?
    
    var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBase()
        
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
    
    func setupBase() {
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
    
    
    

    @IBAction func clickLoginButton(_ sender: UIButton) {
        
        viewModel?.submit()
        
    }

    @objc func clickAppleSignInButton() {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()

        viewModel?.loginWithApple(viewController: self)
        
    }
    
    @IBAction func clickOAuthLogin(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            viewModel?.loginWithGoogle(viewController: self)
     
        } else if sender.tag == 2 {
            
            AuthManager.shared.facebookSignIn(viewController: self) { [weak self] result in
                            
                switch result {
                case .success(let userInfo):
                    self?.viewModel?.isRegisteredUser(authUserInfo: userInfo)
                    //self?.showMessageHandler?(.success, "登入成功")
                case .failure(let error):
                    print(error.localizedDescription)
                    //self?.showMessageHandler?(.failure, "登入失敗！請確認是否已申請帳號或輸入帳密是否錯誤")
                }

            }
            
        }
    }

}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        let credentialUser = CredentialUser(credentials: credentials)
        
        let userInfo = UserInfo(id: credentialUser.id,
                                name: credentialUser.lastName + credentialUser.firstName,
                                email: credentialUser.email,
                                phone: nil, photoURL: "",
                                groups: nil)

        viewModel?.isRegisteredUser(authUserInfo: userInfo)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

}

struct CredentialUser {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    init(credentials: ASAuthorizationAppleIDCredential) {
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }

}
