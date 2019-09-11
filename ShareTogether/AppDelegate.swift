//
//  AppDelegate.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        GIDSignIn.sharedInstance().delegate = FirebaseAuth.shared
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        self.window?.makeKeyAndVisible()
        
        self.window!.tintColor = .STTintColor
        
        if FirebaseAuth.shared.isSignIn() {
            self.window?.rootViewController = UIStoryboard.main.instantiateInitialViewController()!
        } else {
            self.window?.rootViewController = UIStoryboard.login.instantiateInitialViewController()!
        }
    
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:])
        -> Bool {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

}
