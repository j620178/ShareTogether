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
    
    var currentUserInfo: UserInfo?
    
    func setCurrentUserInfo(_ userInfo: UserInfo) {
        print(userInfo)
        if userInfo.id != currentUserInfo?.id {
            currentUserInfo = userInfo
            if let data = try? JSONEncoder().encode(userInfo) {
                UserDefaults.standard.set(data, forKey: UserInfoConstant.currentUserInfo)
            }
        }
    }
    
    var currentGroupInfo: GroupInfo?
    
    func setCurrentGroupInfo(_ groupInfo: GroupInfo) {
        
        if groupInfo.id != currentGroupInfo?.id {
            currentGroupInfo = groupInfo
            if let data = try? JSONEncoder().encode(groupInfo) {
                UserDefaults.standard.set(data, forKey: UserInfoConstant.currentGroupInfo)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentGroup"), object: self, userInfo: nil)
        }

    }
    
    var currentGroupStatus: Int? {
        
        guard let currentGroupID = currentGroupInfo?.id,
            let userGroups = currentUserInfo?.groups
        else { return nil }
        
        for userGroup in userGroups where userGroup.id == currentGroupID {
            return userGroup.status
        }
        
        return nil
    }
    
    func removeCurrentGroupInfo() {

        UserDefaults.standard.removeObject(forKey: UserInfoConstant.currentGroupInfo)
  
    }
    
    func removeCurrentUserInfo() {

        UserDefaults.standard.removeObject(forKey: UserInfoConstant.currentUserInfo)

    }

}
