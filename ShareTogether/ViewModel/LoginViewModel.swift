//
//  LoginViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import AuthenticationServices

enum MessageType {
    case success
    case failure
    case loading
}


class LoginViewModel {
        
    weak var coordinatorDelegate: LoginCoordinatorDelegate?
    
    var showMessageHandler: ((MessageType, String) -> Void)?
    
    var loadingHandler: (() -> Void)?
    
    var isLoading = false
    
    var email: String = ""
    
    var password: String = ""
    
    func submit() {
        
        if email == "" || password == "" {
            showMessageHandler?(.failure, "請輸入完整資訊")
        } else {
            
            isLoading = true
            
            AuthManager.shared.emailSignIn(email: email,
                                           password: password) { [weak self] result in
                                                
                                            switch result {
                                                    
                                            case .success(let userInfo):
                                                self?.isRegisteredUser(authUserInfo: userInfo)
                                                self?.showMessageHandler?(.success, "登入成功")
                                            case .failure(let error):
                                                self?.showMessageHandler?(.failure, "登入失敗！請確認是否已申請帳號或輸入帳密是否錯誤")
                                            }
                
            }
            
        }
        
    }
    
    func loginWithApple(viewController: UIViewController) {
        

        
    }
    
    func loginWithFB() {
        

            
    }
    
    func loginWithGoogle(viewController: LoginViewController) {
    
        AuthManager.shared.googleSignIn(viewController: viewController) { [weak self] result in
                        
            switch result {
            case .success(let userInfo):
                self?.isRegisteredUser(authUserInfo: userInfo)
                self?.showMessageHandler?(.success, "登入成功")
            case .failure(let error):
                self?.showMessageHandler?(.failure, "登入失敗！請確認是否已申請帳號或輸入帳密是否錯誤")
            }
        }
        
    }
    
//    func showHomeVC() {
//
//        if presentingViewController != nil {
//            let presentingVC = presentingViewController
//            dismiss(animated: false) {
//                presentingVC?.dismiss(animated: false)
//            }
//        } else {
//            let nextVC = UIStoryboard.main.instantiateInitialViewController()!
//            nextVC.modalPresentationStyle = .fullScreen
//            present(nextVC, animated: true, completion: nil)
//        }
//
//    }
    
    func isRegisteredUser(authUserInfo: UserInfo) {

        FirestoreManager.shared.getUserInfo(uid: authUserInfo.id) { [weak self] result in
                    
            switch result {
                
            case .success(let userInfo):
                
                if let realUserInfo = userInfo {
                    self?.signInOfRegisteredUser(userInfo: realUserInfo)
                } else {
                    self?.signInOfNewUser(userInfo: authUserInfo)
                }
                
            case .failure(let error):
                
                print(error)
            }
            
        }
        
    }
    
    func signInOfNewUser(userInfo: UserInfo) {
        
        FirestoreManager.shared.addNewUser(userInfo: userInfo) { [weak self] result in
            switch result {
                
            case .success(let demoGroup):
                var userInfo = userInfo
                userInfo.groups = [demoGroup]
                CurrentManager.shared.setCurrentUser(userInfo)
                CurrentManager.shared.setCurrentGroup(demoGroup)
                self?.showMessageHandler?(.success, "登入成功")
                //self?.showHomeVC()
            case .failure:
                LKProgressHUD.dismiss()
                print("error")
            }

        }
    
    }
    
    func signInOfRegisteredUser(userInfo: UserInfo) {
         
         if let groups = userInfo.groups, !groups.isEmpty {
             let group = GroupInfo(id: groups[0].id,
                                   name: groups[0].name,
                                   coverURL: groups[0].coverURL,
                                   status: nil)
             CurrentManager.shared.setCurrentUser(userInfo)
             CurrentManager.shared.setCurrentGroup(group)
             showMessageHandler?(.success, "登入成功")
             //showHomeVC()
 
        }
    }
        
}
