//
//  SelectionGroupViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/15.
//  Copyright © 2019 littema. All rights reserved.
//

class GroupListViewModel {
    
    var userGroups = [GroupInfo]()
    
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
 
    func createCellViewModel(group: GroupInfo) -> GroupCellViewModel {
        
        if CurrentManager.shared.group?.id == group.id {
            return GroupCellViewModel(name: group.name,
                                      groupID: group.id,
                                      coverURL: group.coverURL,
                                      isCurrent: true)
        } else {
            return GroupCellViewModel(name: group.name,
                                      groupID: group.id,
                                      coverURL: group.coverURL,
                                      isCurrent: false)
        }
    }
    
    func getCellViewModel(at index: Int) -> GroupCellViewModel {
        return cellViewModels[index]
    }
    
    func getUserGroup(at index: Int) -> GroupInfo {
        return userGroups[index]
    }
    
    func fetchDate() {
        FirestoreManager.shared.getUserGroups { [weak self] userGroups in
            
            guard let strongSelf = self else { return }
            
            strongSelf.userGroups = userGroups
            var viewModels = [GroupCellViewModel]()
            for userGroup in userGroups {
                let viewModel = strongSelf.createCellViewModel(group: userGroup)
                viewModels.append(viewModel)
            }
            strongSelf.cellViewModels = viewModels
        }
    }
    
}
