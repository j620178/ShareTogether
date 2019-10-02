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
        
        guard let userInfo = CurrentManager.shared.user else { return }
        
        FirestoreManager.shared.getActivity(uid: userInfo.id) { [weak self] result in
            switch result {
                
            case .success(let activities):
                activities.map({ $0.status == ActivityStatus.loaded.rawValue })
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
            
            if ActivityType(rawValue: activity.type) == ActivityType.invite {
                text = "\(activity.pushUser.name) 邀請您加入 \(groupInfo.name) 群組"
            } else if ActivityType(rawValue: activity.type) == ActivityType.addExpense {
                text = "\(activity.pushUser.name) 於 \(groupInfo.name) 增加了一筆消費"
            } else if ActivityType(rawValue: activity.type) == ActivityType.editExpense {
                text = "\(activity.pushUser.name) 於 \(groupInfo.name) 編輯了一筆消費"
            } else if ActivityType(rawValue: activity.type) == ActivityType.addNote {
                text = "\(activity.pushUser.name) 於 \(groupInfo.name) 編輯了一筆消費"
            }
            
            let viewModel = ActivityCellViewModel(type: activity.type,
                                                  mainPhotoImageURL: groupInfo.coverURL,
                                                  userImageURL: activity.pushUser.photoURL,
                                                  desc: text,
                                                  time: activity.time.toNowFormat,
                                                  status: activity.status)
            
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
                
                FirestoreManager.shared.updateGroupMemberStatus(groupID: groupInfo.id,
                                                           memberInfo: strongSelf.activities[indexPath.row].targetMember,
                                                           status: .joined,
                                                           completion: nil)
            
                FirestoreManager.shared.updateActivityType(id: strongSelf.activities[indexPath.row].id,
                                                           type: .acceptMember)
                
            case .failure:
                print("failure")
            }
        }
        
    }
    
}
