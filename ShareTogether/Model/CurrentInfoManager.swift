//
//  UserInfoManager.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/14.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

struct CurrentInfoConstant {
    static let user = "currentUserInfo"
    static let group = "currentGroupInfo"
}

class CurrentInfoManager {
    
    static let shared = CurrentInfoManager()
    
    let userDefault = UserDefaults.standard
    
    var user: UserInfo?
    
    func setCurrentUser(_ userInfo: UserInfo) {
        print(userInfo)
        if userInfo.id != user?.id {
            user = userInfo
            if let data = try? JSONEncoder().encode(userInfo) {
                UserDefaults.standard.set(data, forKey: CurrentInfoConstant.user)
            }
        }
    }
    
    var group: GroupInfo?
    
    func setCurrentGroup(_ groupInfo: GroupInfo) {
        
        if groupInfo.id != group?.id {
            
            group = groupInfo
            
            if let data = try? JSONEncoder().encode(groupInfo) {
                UserDefaults.standard.set(data, forKey: CurrentInfoConstant.group)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentGroup"),
                                            object: self,
                                            userInfo: nil)
            
            FirestoreManager.shared.getMembers { [weak self] result in
                switch result {
                    
                case .success(let members):
                    self?.members = members
                case .failure(let error):
                    LKProgressHUD.showFailure(text: error.localizedDescription)
                }
            }
        }

    }
    
    var groupStatus: Int? {
        
        guard let currentGroupID = group?.id,
            let userGroups = user?.groups
        else { return nil }
        
        for userGroup in userGroups where userGroup.id == currentGroupID {
            return userGroup.status
        }
        
        return nil
    }
    
    var members = [MemberInfo]()
    
    func getMemberInfo(uid: String) -> MemberInfo? {
        for member in members where member.id == uid {
            return member
        }
        
        return nil
    }
    
    func removeCurrentGroup() {

        UserDefaults.standard.removeObject(forKey: CurrentInfoConstant.group)
  
    }
    
    func removeCurrentUser() {

        UserDefaults.standard.removeObject(forKey: CurrentInfoConstant.user)

    }

}
