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
}

class UserInfoManager {
    
    static let shaered = UserInfoManager()
    
    let userDefault = UserDefaults.standard
    
    var currentGroup: UserGroup? {
        guard let currentGroupDic = userDefault.value(forKey: UserInfoConstant.currentGroup) as? [String] else { return nil }
        return userGroupTrans(userInfo: currentGroupDic)
    }
    
    func setCurrentGroup(_ group: UserGroup) {
        userDefault.set(userGroupTrans(userGroup: group), forKey: UserInfoConstant.currentGroup)
    }
    
    func userGroupTrans(userInfo: [String]) -> UserGroup {
        return UserGroup(id: userInfo[0], name: userInfo[1], status: userInfo[2])
    }
    
    func userGroupTrans(userGroup: UserGroup) -> [String] {
        return [userGroup.id, userGroup.name, userGroup.status]
    }
    
}
