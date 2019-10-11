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
            
            window.rootViewController?.present(navigationController, animated: true, completion: nil)
            
        case .edit:
            
            let groupVC = GroupViewController.instantiate(name: .group)
    
            groupVC.type = .edit
    
            navigationController.viewControllers.append(groupVC)
                
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
        
        delegate?.didFinishFrom(self)
    }
    
    func showInviteViewControllerFrom(_ viewController: STBaseViewController, type: GroupType) {
        
        if type == .edit {

            let inviteVC = InviteViewController.instantiate(name: .group)

            inviteVC.type = .edit

            navigationController.pushViewController(inviteVC, animated: true)

        } else if type == .add {

            let inviteVC = InviteViewController.instantiate(name: .group)

            navigationController.pushViewController(inviteVC, animated: true)
        }
    }
    
    func dismissAddGroupFrom(_ viewController: STBaseViewController) {
        
        //viewController.dismiss(animated: true, completion: nil)
        
        navigationController.popViewController(animated: true)
        
        delegate?.didFinishFrom(self)
    }
    
    func dismissEditGroupFrom(_ viewController: STBaseViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
        
        delegate?.didFinishFrom(self)
    }
}
