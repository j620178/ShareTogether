//
//  InviteViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/16.
//  Copyright © 2019 littema. All rights reserved.
//

class InviteViewModel {
    
    var inviteMemberData = [MemberInfo]()
    
    var result: (type: Int, userInfo: UserInfo?)? {
        didSet {
            guard let userInfo = result?.userInfo, let type = result?.type else {
                
                updateButtonStatus?("查無使用者，請重新輸入", nil, false, true)
                
                return
            }
                
            if GroupType(rawValue: type) == .add {
                
                updateButtonStatus?(userInfo.name, userInfo.photoURL, false, true)

            } else {
                
                let members = CurrentManager.shared.availableMembers
                
                let isContainMember = members.contains {
                    $0.id == userInfo.id &&
                    $0.status != MemberStatusType.quit.rawValue
                }
                
                if isContainMember {
                    
                    updateButtonStatus?(userInfo.name, userInfo.photoURL, false, false)

                } else {
                    
                    updateButtonStatus?(userInfo.name, userInfo.photoURL, false, true)
                }
            }
        }
    }
    
    var updateButtonStatus: ((String, String?, Bool, Bool) -> Void)?
        
    func searchUser(type: Int, email: String?, phone: String?) {
        
        FirestoreManager.shared.searchUser(email: email, phone: phone) { [weak self] result in
            switch result {
                
            case .success(let userInfo):
                
                self?.result = (type: type, userInfo: userInfo)
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func addInviteMembers() {
        
        guard let userInfo = result?.userInfo else { return }
        
        inviteMemberData.append(MemberInfo(userInfo: userInfo, status: 1))
    }
    
    func inviteMember() {
        
        guard let userInfo = result?.userInfo else { return }
        
        let memberInfo = MemberInfo(userInfo: userInfo, status: MemberStatusType.inviting.rawValue)
        
        FirestoreManager.shared.addMember(memberInfo: memberInfo)
    }
    
    func getInviteMembers() -> [MemberInfo] {
        
        return inviteMemberData
    }
}
