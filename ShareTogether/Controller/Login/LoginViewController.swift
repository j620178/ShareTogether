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
    
    @IBAction func clickLoginButton(_ sender: UIButton) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            LKProgressHUD.showFailure(text: "請輸入完整資訊", view: self.view)
        } else {
            
            LKProgressHUD.showLoading(view: self.view)
            
            AuthManager.shared.emailSignIn(email: emailTextField.text!,
                                            password: passwordTextField.text!) { [weak self] result in
                                                
                                                guard let strougSelf = self else { return }
                                                
                                                switch result {
                                                    
                                                case .success(let userInfo):
                                                    self?.checkUserGroup(authUserInfo: userInfo)
                                                    LKProgressHUD.showSuccess(text: "登入成功", view: strougSelf.view)
                                                case .failure(let error):
                                                    LKProgressHUD.showFailure(text: "登入失敗！請確認是否已申請帳號或輸入帳密是否錯誤", view: strougSelf.view)
                                                    print(error.localizedDescription)
                                                }
                
            }
            
        }
        
    }

    @objc func clickAppleSignInButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
    @IBAction func clickOAuthLogin(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            AuthManager.shared.googleSignIn(viewContorller: self) { [weak self] result in
                
                guard let strougSelf = self else { return }
                
                switch result {
                case .success(let userInfo):
                    self?.checkUserGroup(authUserInfo: userInfo)
                    LKProgressHUD.showSuccess(text: "登入成功", view: strougSelf.view)
                case .failure(let error):
                    LKProgressHUD.showFailure(text: "登入失敗！請確認是否已申請帳號或輸入帳密是否錯誤", view: strougSelf.view)
                    print(error.localizedDescription)
                }
            }
            
        } else if sender.tag == 2 {
            
            AuthManager.shared.facebookSignIn(viewContorller: self) { [weak self] result in
                
                guard let strougSelf = self else { return }
                
                switch result {
                case .success(let userInfo):
                    self?.checkUserGroup(authUserInfo: userInfo)
                    LKProgressHUD.showSuccess(text: "登入成功", view: strougSelf.view)
                case .failure(let error):
                    LKProgressHUD.showFailure(text: "登入失敗！請確認是否已申請帳號或輸入帳密是否錯誤", view: strougSelf.view)
                    print(error.localizedDescription)
                }

            }
            
        }
        
    }
    
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
    
    func checkUserGroup(authUserInfo: UserInfo) {

        FirestoreManager.shared.getUserInfo(uid: authUserInfo.id) { [weak self] result in
            
            guard let strougSelf = self else { return }
            
            switch result {
                
            case .success(let userInfo):
                    
                if let userInfo = userInfo, let groups = userInfo.groups, !groups.isEmpty {
                    let group = GroupInfo(id: groups[0].id,
                                          name: groups[0].name,
                                          coverURL: groups[0].coverURL,
                                          status: nil)
                    CurrentManager.shared.setCurrentUser(userInfo)
                    CurrentManager.shared.setCurrentGroup(group)
                    LKProgressHUD.showSuccess(text: "登入成功", view: strougSelf.view)
                    self?.showHomeVC()
                } else {
                    FirestoreManager.shared.addNewUser(userInfo: authUserInfo) { result in
                        switch result {
                            
                        case .success(let demoGroup):
                            var userInfo = authUserInfo
                            userInfo.groups = [demoGroup]
                            CurrentManager.shared.setCurrentUser(userInfo)
                            CurrentManager.shared.setCurrentGroup(demoGroup)
                            LKProgressHUD.showSuccess(text: "登入成功", view: strougSelf.view)
                            self?.showHomeVC()
                        case .failure:
                            LKProgressHUD.dismiss()
                            print("error")
                        }

                    }
                }
                
            case .failure(let error):
                LKProgressHUD.dismiss()
                print(error)
            }
            
        }
        
    }
    
    func showHomeVC() {
        
        if presentingViewController != nil {
            let presentingVC = presentingViewController
            dismiss(animated: false) {
                presentingVC?.dismiss(animated: false)
            }
        } else {
            let nextVC = UIStoryboard.main.instantiateInitialViewController()!
            nextVC.modalPresentationStyle = .fullScreen
            present(nextVC, animated: true, completion: nil)
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

        checkUserGroup(authUserInfo: userInfo)
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
