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

class AuthManager: NSObject {
    
    static var shared = AuthManager()
    
    var googleSignInHandler: ((Bool) -> Void)?
    
    var uid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    var isSignIn: Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
        
    func createNewUser(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            completion(result?.user.email)
            //print(.displayName)
            print(error ?? "error")
        }
    }
    
    func emailSignIn(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            completion(result?.user.email)
            print(error ?? "error")
        }
    }
    
    func facebookSignIn(viewContorller: UIViewController, completion: @escaping (Bool) -> Void) {
        let fbLoginManager = LoginManager()

        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: viewContorller) { (result, error) in
            
            if error != nil {
                return
            }
            
            if AccessToken.current == nil {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                
                if error != nil {
                    print("使用FB error")
                    print((error?.localizedDescription)!)
                    return
                }

                print("使用FB登入成功")
                completion(self.isSignIn)
            })
            
        }

    }
    
    func googleSignIn(viewContorller: LoginViewController, completion: @escaping (Bool) -> Void) {
        
        GIDSignIn.sharedInstance().uiDelegate = viewContorller
        //GIDSignIn.sharedInstance().signInSilently()
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
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            self.googleSignInHandler?(true)
        }
        
    }
    
}

extension LoginViewController: GIDSignInUIDelegate { }
