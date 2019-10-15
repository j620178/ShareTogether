//
//  LoginViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

enum LoginError: Error {
    
    case empty
    
    case failure
}

typealias LoginResult = (Result<String, LoginError>) -> Void

class LoginViewModel {
    
    var isLoading: Bool = false {
         didSet {
             loadingHandler?(isLoading)
         }
    }
         
    var loadingHandler: ((Bool) -> Void)?
    
    func loginWithEmail(email: String,
                        password: String,
                        completion: @escaping LoginResult) {
        
        guard email != "" || password != "" else {
            
            completion(Result.failure(.empty))
            
            return
        }
        
        isLoading = true
        
        AuthManager.shared
            .emailSignIn(email: email,
                         password: password) { [weak self] result in
                            
                            switch result {
                            
                            case .success(let userInfo):
                                
                                self?.checkRegister(authUserInfo: userInfo, completion: completion)
                                
                            case .failure:
                                
                                self?.isLoading = false
                                
                                completion(Result.failure(.failure))
                                
                            }
            
        }
        
    }
    
    func loginWithFacebook(viewController: LoginViewController,
                           completion: @escaping LoginResult) {
        
        AuthManager.shared.facebookSignIn(viewController: viewController) { [weak self] result in
                        
            switch result {
                
            case .success(let userInfo):
                
                self?.checkRegister(authUserInfo: userInfo, completion: completion)
                
            case .failure:
                
                self?.isLoading = false
                
                completion(Result.failure(.failure))
                
            }
        }
        
    }
    
    func loginWithGoogle(viewController: LoginViewController,
                         completion: @escaping LoginResult) {
    
        AuthManager.shared.googleSignIn(viewController: viewController) { [weak self] result in
                        
            switch result {

            case .success(let userInfo):

                self?.checkRegister(authUserInfo: userInfo, completion: completion)

            case .failure:

                self?.isLoading = false

                completion(Result.failure(.failure))

            }
        }
        
    }
    
    func loginWithApple(viewController: LoginViewController,
                        completion: @escaping LoginResult) {
    
        AuthManager.shared.appleSignIn(viewController: viewController) { [weak self] result in
                        
            switch result {
                
            case .success(let userInfo):
                
                self?.checkRegister(authUserInfo: userInfo, completion: completion)
                
            case .failure:
                
                self?.isLoading = false
                
                completion(Result.failure(.failure))
                
            }
        }
        
    }
    
    func checkRegister(authUserInfo: UserInfo,
                       completion: @escaping LoginResult) {
        
        isLoading = true

        FirestoreManager.shared.getUserInfo(uid: authUserInfo.id) { [weak self] result in
                    
            switch result {
                
            case .success(let userInfo):
                                
                if let realUserInfo = userInfo {
                    
                    self?.signInWithRegisteredUser(userInfo: realUserInfo, completion: completion)
                    
                } else {
                    
                    self?.signInWithNewUser(userInfo: authUserInfo, completion: completion)
                    
                }
            
            case .failure:
                
                self?.isLoading = false
                
                completion(Result.failure(.failure))
            }
            
        }
        
    }
    
    func signInWithNewUser(userInfo: UserInfo,
                           completion: @escaping LoginResult) {
        
        FirestoreManager.shared.addNewUser(userInfo: userInfo) { [weak self] result in
            
            self?.isLoading = false
                        
            switch result {
                
            case .success(let demoGroup):
                
                var userInfo = userInfo
                
                userInfo.groups = [demoGroup]
                
                CurrentManager.shared.setCurrentUser(userInfo)
                
                CurrentManager.shared.setCurrentGroup(demoGroup)
                
                completion(Result.success("歡迎加入 ShareTogether!"))

            case .failure:
                                
                completion(Result.failure(.failure))
                
            }
        }
    }
    
    func signInWithRegisteredUser(userInfo: UserInfo,
                                  completion: @escaping LoginResult) {
        
        isLoading = false
         
        guard let groups = userInfo.groups, let firstGroup = groups.first else { return }
        
        let group = GroupInfo(id: firstGroup.id,
                              name: firstGroup.name,
                              coverURL: firstGroup.coverURL,
                              status: nil)
            
        CurrentManager.shared.setCurrentUser(userInfo)
        
        CurrentManager.shared.setCurrentGroup(group)
        
        completion(Result.success("歡迎您回來!"))
    }
}
