//
//  UserInfoManager.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/14.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

struct UserInfoConstant {
    static let currentGroup = "currentGroup"
    static let currentUserInfo = "currentUserInfo"
}

class UserInfoManager {
    
    static let shaered = UserInfoManager()
    
    let userDefault = UserDefaults.standard
    
    var currentUserInfo: UserInfo? {
        if let data = userDefault.value(forKey: UserInfoConstant.currentUserInfo) as? Data,
            let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data) {
            return userInfo
        }
        return nil
    }
    
    func setCurrentUserInfo(_ userInfo: UserInfo) {
        if let data = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(data, forKey: UserInfoConstant.currentUserInfo)
        }
    }
    
    var currentGroup: UserGroup? {
        if let data = userDefault.value(forKey: UserInfoConstant.currentGroup) as? Data,
            let userGroup = try? JSONDecoder().decode(UserGroup.self, from: data) {
            return userGroup
        }
        return nil
    }
    
    func setCurrentGroup(_ group: UserGroup) {
        if let data = try? JSONEncoder().encode(group) {
            UserDefaults.standard.set(data, forKey: UserInfoConstant.currentGroup)
        }
    }
    
}
