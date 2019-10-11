//
//  PushNotification.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/2.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

private struct FCMConstant {
    static let privateInfo = "PrivateInfo"
    static let plist = "plist"
    static let pushUrl = "FirebasePushURL"
    static let notification = "notification"
    static let to = "to"
    static let title = "title"
    static let body = "body"
    static let badge = "badge"
    static let data = "data"
    static let expenseID = "expenseID"
    static let fcmKey = "FCMKey"
}

enum PushNotification: RestAPIRequest {
    
    case send(token: String, title: String?, body: String?, expenseID: String?, badge: Int)
    
    var url: String {
        switch self {
        case .send:
            guard let url = Bundle.main.infoDictionary?[FCMConstant.pushUrl] as? String
                else {
                fatalError()
            }
            return url
        }
    }
    
    var header: [String: String] {
        switch self {
        case .send:
            guard let path = Bundle.main.path(forResource: FCMConstant.privateInfo, ofType: FCMConstant.plist),
                let dict = NSDictionary(contentsOfFile: path),
                let body = dict as? [String: String],
                let key = body[FCMConstant.fcmKey]
            else {
                fatalError()
            }
            return [HTTPHeaderKey.contentType.rawValue: HTTPHeaderValue.applicationJson.rawValue,
                    HTTPHeaderKey.authorization.rawValue: key]
        }
    }
    
    var body: Data? {
        
        switch self {
            
        case .send(let token, let title, let desc, let expenseID, let badge):
            
            var body = [String: Any]()
            
            if let title = title, let desc = desc {
                body = [FCMConstant.to: token,
                        FCMConstant.data: [FCMConstant.expenseID: expenseID],
                        FCMConstant.notification: [FCMConstant.title: title,
                                                   FCMConstant.body: desc,
                                                   FCMConstant.badge: badge]]
            } else if let title = title {
                body = [FCMConstant.to: token,
                        FCMConstant.data: [FCMConstant.expenseID: expenseID],
                        FCMConstant.notification: [FCMConstant.title: title,
                                                   FCMConstant.badge: badge]]
            } else if let desc = desc {
                body = [FCMConstant.to: token,
                        FCMConstant.data: [FCMConstant.expenseID: expenseID],
                        FCMConstant.notification: [FCMConstant.body: desc,
                                                   FCMConstant.badge: badge]]
            } else {
                body = [FCMConstant.to: token,
                        FCMConstant.data: [FCMConstant.expenseID: expenseID],
                        FCMConstant.notification: [FCMConstant.badge: badge]]
            }
            
             return try? JSONSerialization.data(withJSONObject: body, options: [])
        }
    }
    
    var method: String {
        switch self {
        case .send:
            return HTTPMethod.POST.rawValue
        }
    }
    
}
