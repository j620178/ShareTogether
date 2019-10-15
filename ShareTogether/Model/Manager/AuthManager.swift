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
import AuthenticationServices

enum AuthManagerError: Error {
    case loginFailed
    case getUserInfoFailed
    case getAccessTokenFailed
}

typealias UserInfoResult = (Result<UserInfo, Error>) -> Void

class AuthManager: NSObject {
    
    static var shared = AuthManager()
    
    var googleSignInHandler: UserInfoResult?
    
    var appleSignInHandler: UserInfoResult?
    
    var appleSigInWindow: UIWindow?

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
    
    func facebookSignIn(viewController: UIViewController, completion: @escaping UserInfoResult) {
        
        let fbLoginManager = LoginManager()

        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { (result, error) in
        
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
    
    func googleSignIn(viewController: LoginViewController,
                      completion: @escaping UserInfoResult) {
        
        GIDSignIn.sharedInstance()?.delegate = self
        
        GIDSignIn.sharedInstance()?.signIn()
        
        googleSignInHandler = completion
    }
    
    func appleSignIn(viewController: UIViewController,
                     completion: @escaping UserInfoResult) {
        
        let provider = ASAuthorizationAppleIDProvider()
         
        let request = provider.createRequest()
         
        request.requestedScopes = [.fullName, .email]
         
        let controller = ASAuthorizationController(authorizationRequests: [request])
         
        controller.delegate = self
         
        controller.presentationContextProvider = self
         
        controller.performRequests()
        
        appleSigInWindow = viewController.view.window
        
        appleSignInHandler = completion
    }

    func signOut() {
        
        let firebaseAuth = Auth.auth()
        
        do {

            try firebaseAuth.signOut()
            
            CurrentManager.shared.removeCurrentUser()
            
            CurrentManager.shared.removeCurrentGroup()
            
            print ("signOut")
            
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

extension AuthManager: ASAuthorizationControllerDelegate {
    
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

        appleSignInHandler?(Result.success(userInfo))
    }
}

extension AuthManager: ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return appleSigInWindow ?? UIWindow()
    }
}

//extension AuthManager: GIDSignInDelegate {
//
//    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//        var photoURL: String?
//
//        if user.profile.hasImage, let urlString = user.profile.imageURL(withDimension: 300) {
//            photoURL = "\(urlString)"
//        }
//
//        let userInfo = UserInfo(id: user.userID,
//                                name: user.profile.name,
//                                email: user.profile.email,
//                                phone: nil,
//                                photoURL: photoURL,
//                                groups: nil)
//
//        googleSignInHandler?()
//
////        viewModel?.checkRegister(authUserInfo: userInfo, completion: { [weak self] result in
////
////            self?.checkLogin(result: result)
////
////        })
//    }
//}
