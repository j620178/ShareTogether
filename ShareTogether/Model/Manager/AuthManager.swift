//
//  AuthManager.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/10.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

enum AuthManagerError: Error {
    case loginFailed
    case getUserInfoFailed
    case getAccessTokenFailed
}

class AuthManager: NSObject {
    
    static var shared = AuthManager()
    
    var googleSignInHandler: ((Result<UserInfo, Error>) -> Void)?

    func createNewUser(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                print(error ?? "error")
                return
            }
            
            completion(result!.user.uid)
            
        }
    }
    
    func emailSignIn(email: String, password: String, completion: @escaping (Result<UserInfo, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                completion(Result.failure(AuthManagerError.loginFailed))
                return
            }
            
            guard let result = result else { return }
            
            FirestoreManager.shared.getUserInfo(uid: result.user.uid) { result in
                switch result {
                    
                case .success(let userInfo):
                    completion(Result.success(userInfo!))
                case .failure:
                    completion(Result.failure(AuthManagerError.getUserInfoFailed))
                }
            }

        }
    }
    
    func facebookSignIn(viewContorller: UIViewController, completion: @escaping (Result<UserInfo, Error>) -> Void) {
        let fbLoginManager = LoginManager()

        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: viewContorller) { (result, error) in
        
            if error != nil {
                completion(Result.failure(AuthManagerError.loginFailed))
                return
            }
            
            if AccessToken.current == nil {
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                
                if error != nil {
                    completion(Result.failure(AuthManagerError.loginFailed))
                    return
                }
                
                guard let user = user,
                    let name = user.user.displayName,
                    let email = user.user.email,
                    let photoURL = user.user.photoURL
                else {
                    completion(Result.failure(AuthManagerError.getUserInfoFailed))
                    return
                }
                
                let userInfo = UserInfo(id: user.user.uid,
                                        name: name,
                                        email: email,
                                        phone: nil,
                                        photoURL: "\(photoURL)",
                                        groups: nil)
                
                completion(Result.success(userInfo))
            })
            
        }

    }
    
    func googleSignIn(viewContorller: LoginViewController,
                      completion: @escaping ((Result<UserInfo, Error>) -> Void)) {
        
        GIDSignIn.sharedInstance().uiDelegate = viewContorller
        GIDSignIn.sharedInstance()?.signIn()
        
        googleSignInHandler = completion
    }

    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            print ("signOut")
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

extension AuthManager: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: authentication.idToken,
            accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { [weak self] (user, error) in
            
            if error != nil {
                self?.googleSignInHandler?(Result.failure(AuthManagerError.loginFailed))
                return
            }
            
            guard let user = user,
                let name = user.user.displayName,
                let email = user.user.email,
                let photoURL = user.user.photoURL
            else { return }
            
            let userInfo = UserInfo(id: user.user.uid,
                                    name: name,
                                    email: email,
                                    phone: nil,
                                    photoURL: "\(photoURL)",
                                    groups: nil)
            
            self?.googleSignInHandler?(Result.success(userInfo))
            
        }
        
    }
    
}

extension LoginViewController: GIDSignInUIDelegate { }
