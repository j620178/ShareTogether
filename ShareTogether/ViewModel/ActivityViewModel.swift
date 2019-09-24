//
//  ActivityViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/23.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class ActivityViewModel {
    
    var activities = [Activity]()
    
    var cellViewModels = [ActivityCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadTableView: (() -> Void)?
    
    func fectchData() {
        
        guard let userInfo = UserInfoManager.shaered.currentUserInfo else { return }
        
        FirestoreManager.shared.getActivity(uid: userInfo.id) { [weak self] result in
            switch result {
                
            case .success(let activities):
                self?.activities = activities
                self?.processViewModel()
            case .failure:
                print("error")
            }
        }
    }
    
    func getViewModelAt(_ indexPath: IndexPath) -> ActivityCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func processViewModel() {
        
        var cellViewModels = [ActivityCellViewModel]()
        
        for activity in activities {
            
            guard let groupInfo = activity.groupInfo else { return }
            
            var text = ""
            
            if ActivityType(rawValue: activity.type) == ActivityType.addExpense {
                text = "\(activity.pushUser.name)於\(groupInfo.name)增加了一筆消費"
            } else if ActivityType(rawValue: activity.type) == ActivityType.addMember {
                text = "\(activity.pushUser.name)於邀請您加入\(groupInfo.name)群組"
            }
            
            let viewModel = ActivityCellViewModel(mainPhotoImageURL: groupInfo.coverURL,
                                                  userImageURL: activity.pushUser.photoURL,
                                                  desc: text,
                                                  time: activity.time.toSimpleFormat())
            cellViewModels.append(viewModel)
        }
        
        self.cellViewModels = cellViewModels
        
    }
    
    func addGroupButton(indexPath: IndexPath) {
        
        guard let groupInfo = activities[indexPath.row].groupInfo else { return }
        
        FirestoreManager.shared.joinGroup(group: groupInfo) { [weak self] result in
            switch result {
                
            case .success:
                guard let strongSelf = self else { return }
                
                FirestoreManager.shared.updateMemberStatus(groupID: groupInfo.id,
                                                           memberInfo: strongSelf.activities[indexPath.row].targetMember,
                                                           status: .joined) { result in
                    switch result {
                        
                    case .success:
                        print("success")
                    case .failure: print("failure")
                    }
                }
                
                //FirestoreManager.shared.deleteActivity(uid: strongSelf.activities[indexPath.row].targetMember.id,
                                                       //id: strongSelf.activities[indexPath.row].id)
                
            case .failure:
                print("failure")
            }
        }
        
    }
    
}
