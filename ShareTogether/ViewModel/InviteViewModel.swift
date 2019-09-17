//
//  InviteViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/16.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

protocol InviteViewModelDelegete: AnyObject {
    func updateView(text: String, imageURL: String?, isButtonHidden: Bool)
}

class InviteViewModel {
    
    var inviteMemberData = [MemberInfo]()
    
    var userInfo: UserInfo? {
        didSet {
            if let userInfo = userInfo {
                delegate?.updateView(text: userInfo.name, imageURL: userInfo.photoURL, isButtonHidden: false)
            } else {
                delegate?.updateView(text: "查無使用者，請重新輸入", imageURL: nil, isButtonHidden: true)
            }
        }
    }
    
    weak var delegate: InviteViewModelDelegete?
    
    func searchUser(email: String?, phone: String?) {
        
        FirestoreManager.shared.searchUser(email: email, phone: phone) { [weak self] result in
            switch result {
                
            case .success(let userInfo):
                self?.userInfo = userInfo
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addInviteMembers() {
        
        guard let userInfo = userInfo else { return }
        inviteMemberData.append(MemberInfo(userInfo: userInfo, status: 1))
        
    }
    
    func inviteMember() {
        
        guard let userInfo = userInfo else { return }
        
        let memberInfo = MemberInfo(userInfo: userInfo, status: MemberStatusType.inviting.rawValue)
        
        FirestoreManager.shared.addMember(memberInfo: memberInfo)
        
    }
    
    func getInviteMembers() -> [MemberInfo] {
        return inviteMemberData
    }
    
}
