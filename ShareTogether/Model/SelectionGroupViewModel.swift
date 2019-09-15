//
//  SelectionGroupViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/15.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class SelectionGroupViewModel {
    
    var userGroups = [UserGroup]()
    
    var cellViewModels = [GroupCellViewModel]() {
        didSet {
            reloadTableViewHandler?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadTableViewHandler: (() -> Void)?
    var showAlertHandler: (() -> Void)?
    var updateLoadingStatusHandler: (() -> Void)?
 
    func createCellViewModels(userGroup: UserGroup) -> GroupCellViewModel {
        
        if UserInfoManager.shaered.currentGroup?.id == userGroup.id {
            return GroupCellViewModel(name: userGroup.name, groupID: userGroup.id, isCurrent: true)
        } else {
            return GroupCellViewModel(name: userGroup.name, groupID: userGroup.id, isCurrent: false)
        }
    }
    
    
    func fetchDate() {
        FirestoreManager.shared.getUserGroups { [weak self] userGroups in
            self?.userGroups = userGroups
        }
    }
    
}
