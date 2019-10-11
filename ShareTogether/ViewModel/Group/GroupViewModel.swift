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
            reloadDataHandler?()
        }
    }
    
    var availableMembers: [MemberInfo] {
    
        return CurrentManager.shared.availableMembers
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
        
        guard let memberStatus = MemberStatusType(rawValue: availableMembers[index].status)?.getString
        else { return nil}
        
        let cellViewModel = MemberCellViewModel(userImageURL: availableMembers[index].photoURL,
                                                userName: availableMembers[index].name,
                                                userDetail: memberStatus)
        
        return cellViewModel
    }
    
}
