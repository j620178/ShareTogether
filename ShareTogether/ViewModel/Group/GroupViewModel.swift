//
//  GroupViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/11.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

class GroupViewModel {
    
    var reloadDataHandler: (() -> Void)?
    
    var members = [MemberInfo]() {
        didSet {
            processData(members: members)
        }
    }

    var availableMembers: [MemberInfo] {
    
        return CurrentManager.shared.availableMembers
    }
    
    var cellViewModels = [MemberCellViewModel]() {
        didSet {
            reloadDataHandler?()
        }
    }
    
    func addGroup(coverImage: UIImage, text: String,
                  completion: @escaping (Result<String, Error>) -> Void) {
                
        StorageManager.shared.uploadImage(image: coverImage) { [weak self] urlString in
            
            guard let strongSelf = self else { return }
            
            let groupInfo = GroupInfo(id: nil, name: text, coverURL: urlString, status: nil)

            FirestoreManager.shared.addGroup(groupInfo: groupInfo,
                                             members: strongSelf.members,
                                             completion: { result in
                                                
                                                completion(result)
            })
        }
    }
    
    func getCellViewModel(index: Int) -> MemberCellViewModel? {
    
        return cellViewModels[index]
    }
    
    func initMember(type: GroupType) {
        
        switch type {

        case .add:
            members = [MemberInfo(userInfo: CurrentManager.shared.user!, status: 0)]
            processData(members: members)
            
        case .edit:
            processData(members: availableMembers)
        }
    }
    
    func processData(members: [MemberInfo]) {
        
        var cellViewModels = [MemberCellViewModel]()
        
        for member in members {
            
            guard let memberStatus = MemberStatusType(rawValue: member.status)?.getString
            else { return }
            
            let cellViewModel = MemberCellViewModel(userImageURL: member.photoURL,
                                                    userName: member.name,
                                                    userDetail: memberStatus)
            cellViewModels.append(cellViewModel)
            
        }
        
        self.cellViewModels = cellViewModels
    }
}
