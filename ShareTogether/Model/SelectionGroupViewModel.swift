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
            reloadDataHandler?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadDataHandler: (() -> Void)?
    var showAlertHandler: (() -> Void)?
    var updateLoadingStatusHandler: (() -> Void)?
 
    func createCellViewModel(userGroup: UserGroup) -> GroupCellViewModel {
        
        if UserInfoManager.shaered.currentGroup?.id == userGroup.id {
            return GroupCellViewModel(name: userGroup.name,
                                      groupID: userGroup.id,
                                      coverURL: userGroup.coverURL,
                                      isCurrent: true)
        } else {
            return GroupCellViewModel(name: userGroup.name,
                                      groupID: userGroup.id,
                                      coverURL: userGroup.coverURL,
                                      isCurrent: false)
        }
    }
    
    func getCellViewModel(at index: Int) -> GroupCellViewModel {
        return cellViewModels[index]
    }
    
    func getUserGroup(at index: Int) -> UserGroup {
        return userGroups[index]
    }
    
    func fetchDate() {
        FirestoreManager.shared.getUserGroups { [weak self] userGroups in
            
            guard let strongSelf = self else { return }
            
            strongSelf.userGroups = userGroups
            var viewModels = [GroupCellViewModel]()
            for userGroup in userGroups {
                let viewModel = strongSelf.createCellViewModel(userGroup: userGroup)
                viewModels.append(viewModel)
            }
            strongSelf.cellViewModels = viewModels
        }
    }
    
}
