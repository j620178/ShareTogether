//
//  AppDelegate.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import Firebase
import FirebaseFirestore
import FirebaseMessaging
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        
        Firestore.firestore()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        GIDSignIn.sharedInstance().delegate = AuthManager.shared
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self

            // 在程式一啟動即詢問使用者是否接受圖文(alert)、聲音(sound)、數字(badge)三種類型的通知
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
                    if granted {
                        print("允許...")
                    } else {
                        print("不允許...")
                    }
                })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
            
        application.registerForRemoteNotifications()
                    
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        self.window?.makeKeyAndVisible()
        
        self.window!.tintColor = .STTintColor
        
        self.window!.overrideUserInterfaceStyle = .light
        
        if let data = UserDefaults.standard.value(forKey: DefaultConstant.user) as? Data,
            let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data) {
            CurrentManager.shared.setCurrentUser(userInfo)
        }
        //refator
        if let data = UserDefaults.standard.value(forKey: DefaultConstant.group) as? Data,
            let groupInfo = try? JSONDecoder().decode(GroupInfo.self, from: data) {
            CurrentManager.shared.setCurrentGroup(groupInfo)
        }
        
        if CurrentManager.shared.user != nil {
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
      
    /// 推播失敗的訊息
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
      
    /// 取得 DeviceToken，通常 for 後台人員推播用
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        // 將 Data 轉成 String
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString: \(deviceTokenString)")

        // 將 Device Token 送到 Server 端...

    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// App 在前景時，推播送出時即會觸發的 delegate
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 印出後台送出的推播訊息(JOSN 格式)
        let userInfo = notification.request.content.userInfo
        print("userInfo: \(userInfo)")
        
        // 可設定要收到什麼樣式的推播訊息，至少要打開 alert，不然會收不到推播訊息
        completionHandler([.badge, .sound, .alert])
    }
    
    /// App 在關掉的狀態下或 App 在背景或前景的狀態下，點擊推播訊息時所會觸發的 delegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // 印出後台送出的推播訊息(JSON 格式)
        let userInfo = response.notification.request.content.userInfo
        print("userInfo: \(userInfo)")
        
        completionHandler()
    }

}

extension AppDelegate: MessagingDelegate {
    
    /// iOS10 含以上的版本用來接收 firebase token 的 delegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        // 用來從 firebase 後台推送單一裝置所必須的 firebase token
        print("Firebase registration token: \(fcmToken)")
        
        CurrentManager.shared.fcmToken = fcmToken
        
//        let pushNotificationProvider = PushNotificationProvider()
//        pushNotificationProvider.send(to: fcmToken, title: "Pony", body: "Ker") { result in
//            switch result {
//
//            case .success(let respond):
//                print(respond)
//            case .failure:
//                print("error")
//            }
//        }
    }
    
}
