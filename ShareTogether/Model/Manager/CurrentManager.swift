//
//  UserInfoManager.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/14.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

struct DefaultConstant {
    static let user = "currentUserInfo"
    static let group = "currentGroupInfo"
}

class CurrentManager {
    
    static let shared = CurrentManager()
    
    let userDefault = UserDefaults.standard
    
    var user: UserInfo?
    
    func setCurrentUser(_ userInfo: UserInfo) {
        print(userInfo)
        if userInfo.id != user?.id {
            var tempUserInfo = userInfo
            tempUserInfo.fcmToken = fcmToken
            user = tempUserInfo
            if let data = try? JSONEncoder().encode(tempUserInfo) {
                UserDefaults.standard.set(data, forKey: DefaultConstant.user)
            }
            
            if let fcmToken = fcmToken {
                FirestoreManager.shared.updateFCMToken(token: fcmToken)
            }
        }
    }
    
    var group: GroupInfo?
    
    func setCurrentGroup(_ groupInfo: GroupInfo) {
        
        if groupInfo.id != group?.id {
            
            group = groupInfo
            
            if let data = try? JSONEncoder().encode(groupInfo) {
                UserDefaults.standard.set(data, forKey: DefaultConstant.group)
            }
            
            FirestoreManager.shared.getMembers { [weak self] result in
                switch result {
                    
                case .success(var members):
                    self?.sortMembers(members: &members)
                    self?.members = members
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentGroup"),
                                                    object: self,
                                                    userInfo: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    //LKProgressHUD.showFailure(text: error.localizedDescription)
                }
            }

        }

    }

    var members = [MemberInfo]()
    
    var availableMembers: [MemberInfo] {
        var availableMembers = [MemberInfo]()
        
        for member in members {
            if MemberStatusType.init(rawValue: member.status) == MemberStatusType.quit ||
                MemberStatusType.init(rawValue: member.status) == MemberStatusType.archive {
            } else {
                availableMembers.append(member)
            }
        }
        
        return availableMembers
    }
    
    var availableMembersWithoutSelf: [MemberInfo] {
        var availableMembers = [MemberInfo]()
        
        for member in members {
            if MemberStatusType.init(rawValue: member.status) == MemberStatusType.quit ||
                MemberStatusType.init(rawValue: member.status) == MemberStatusType.archive {
            } else if member.id != CurrentManager.shared.user?.id {
                availableMembers.append(member)
            }
        }
        
        return availableMembers
    }
    
    func getMemberInfo(uid: String) -> MemberInfo? {
        for member in members where member.id == uid {
            return member
        }
        
        return nil
    }
    
    func sortMembers(members: inout [MemberInfo]) {
        guard let user = CurrentManager.shared.user else { return }
        
        for index in members.indices where members[index].id == user.id {
            let temp = members.remove(at: index)
            members.insert(temp, at: 0)
        }
    }
    
    var fcmToken: String? {
        didSet {
            guard let fcmToken = fcmToken else { return }
            FirestoreManager.shared.updateFCMToken(token: fcmToken)
        }
    }

    func removeCurrentGroup() {

      UserDefaults.standard.removeObject(forKey: DefaultConstant.group)

    }

    func removeCurrentUser() {

      UserDefaults.standard.removeObject(forKey: DefaultConstant.user)

    }

}
