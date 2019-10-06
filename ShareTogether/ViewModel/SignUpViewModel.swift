//
//  SignUpViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/5.
//  Copyright © 2019 littema. All rights reserved.
//

enum SignUpError: Error {
    case empty
    case failure
}

class SignUpViewModel {
    
    typealias SignUpResult = (Result<String, SignUpError>) -> Void
    
    var isLoading: Bool = false {
         didSet {
             loadingHandler?(isLoading)
         }
    }
    
    var loadingHandler: ((Bool) -> Void)?
    
    func signUp(userName: String,
                email: String,
                password: String,
                completion: @escaping SignUpResult) {
        
        if userName == "" || email == "" || password == "" {
            
            completion(Result.failure(.empty))
            
        } else {
            
            isLoading = true
            
            AuthManager.shared
                .createNewUser(email: email,
                               password: password) { [weak self] uid in
                                
                                let userInfo = UserInfo(id: uid,
                                                        name: userName,
                                                        email: email,
                                                        phone: nil,
                                                        photoURL: nil,
                                                        groups: nil)
                                
                                FirestoreManager.shared
                                    .addNewUser(userInfo: userInfo) { [weak self] result in
                                                                                                        
                                        self?.isLoading = false

                                        switch result {
                                                        
                                        case .success:
                                            
                                            completion(Result.success("註冊成功"))
                                        
                                        case .failure:
                                            
                                            completion(Result.failure(.failure))
                                        }
                                }
            }
        }
    }
    
}
