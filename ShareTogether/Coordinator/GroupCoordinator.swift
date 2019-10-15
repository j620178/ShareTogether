//
//  GroupCoordinator.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/11.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import Foundation

protocol GroupCoordinatorDelegate: AnyObject {
    
    func didFinishFrom(_ coordinator: Coordinator)
}

class GroupCoordinator: NSObject, Coordinator {
    
    private var childCoordinators = [Coordinator]()
    
    var navigationController = STNavigationController()
    
    weak var delegate: GroupCoordinatorDelegate?
    
    let window: UIWindow
    
    let type: GroupType
        
    init(window: UIWindow, type: GroupType) {
        
        self.window = window
        
        self.type = type
    }
    
    func start() {
        
        switch type {

        case .add:
            
            let groupListVC = GroupListViewController.instantiate(name: .group)
                            
            groupListVC.viewModel = GroupListViewModel()
            
            groupListVC.coordinator = self
            
            navigationController.viewControllers.append(groupListVC)
            
            navigationController.modalPresentationStyle = .overFullScreen
            
            window.rootViewController?.present(navigationController, animated: true, completion: nil)
            
        case .edit:
            
            let groupVC = GroupViewController.instantiate(name: .group)
            
            groupVC.coordinator = self
            
            groupVC.viewModel = GroupViewModel()
            
            groupVC.type = .edit
    
            navigationController.viewControllers.append(groupVC)
            
            navigationController.modalPresentationStyle = .overFullScreen
                
            window.rootViewController?.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
}

extension GroupCoordinator: GroupListVCCoordinatorDelegate {
    
    func showGroupViewControllerFrom(_ viewController: STBaseViewController) {
        
        let groupVC = GroupViewController.instantiate(name: .group)
                
        groupVC.viewModel = GroupViewModel()
        
        groupVC.coordinator = self
        
        navigationController.pushViewController(groupVC, animated: true)
    }
    
    func dismissGroupListViewControllerFrom(_ viewController: STBaseViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
        
        delegate?.didFinishFrom(self)
    }
}

extension GroupCoordinator: GroupVCCoordinatorDelegate {
    
    func didFinishEditGroupFrom(_ viewController: STBaseViewController) {
        
        delegate?.didFinishFrom(self)
    }
    
    func didFinishAddGroupFrom(_ viewController: STBaseViewController) {
        
        navigationController.popViewController(animated: true)
    }
    
    func showInviteViewControllerFrom(_ viewController: STBaseViewController, type: GroupType) {
        
        let inviteVC = InviteViewController.instantiate(name: .group)
        
        inviteVC.coordinator = self
        
        inviteVC.viewModel = InviteViewModel()
        
        inviteVC.type = type
        
        navigationController.pushViewController(inviteVC, animated: true)
    }
    
    func dismissAddGroupFrom(_ viewController: STBaseViewController) {
                
        navigationController.popViewController(animated: true)
        
        delegate?.didFinishFrom(self)
    }
    
    func dismissEditGroupFrom(_ viewController: STBaseViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
        
        delegate?.didFinishFrom(self)
    }
}

extension GroupCoordinator: InviteVCCoordinatorDelegate {
    
    func didFinishInviteFrom(_ viewController: STBaseViewController, members: [MemberInfo]?) {
        
        guard let members = members else { return }
        
        for viewController in navigationController.viewControllers {

            if let previousVC = viewController as? GroupViewController {

                for inviteMember in members {

                    let result = previousVC.viewModel?.members.contains { memberInfo -> Bool in

                        return memberInfo.id == inviteMember.id
                    }

                    if let realResult = result, !realResult {
                        
                        previousVC.viewModel?.members.append(inviteMember)
                    }
                }
            }
        }
    }
}
