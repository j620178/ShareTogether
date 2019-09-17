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
    static let currentGroupInfo = "currentGroupInfo"
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
    
    var currentGroupInfo: GroupInfo? {
        if let data = userDefault.value(forKey: UserInfoConstant.currentGroupInfo) as? Data,
            let groupInfo = try? JSONDecoder().decode(GroupInfo.self, from: data) {
            return groupInfo
        }
        return nil
    }
    
    func setCurrentGroupInfo(_ groupInfo: GroupInfo) {
        if let data = try? JSONEncoder().encode(groupInfo) {
            UserDefaults.standard.set(data, forKey: UserInfoConstant.currentGroupInfo)
        }
    }
    
    var currentGroupStatus: Int? {
        
        guard let currentGroupID = currentGroupInfo?.id,
            let userGroups = currentUserInfo?.groups
        else { return nil }
        
        for userGroup in userGroups {
            if userGroup.id == currentGroupID {
                return userGroup.status
            }
        }
        
        return nil
    }
    
    
    
}
