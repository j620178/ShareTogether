//
//  HomeCoordinator.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/6.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    
    func didFinishFrom(_ coordinator: Coordinator)
}

class HomeCoordinator: NSObject, Coordinator {
    
    private var childCoordinators = [Coordinator]()
    
    let navController = STNavigationController()
    
    weak var delegate: HomeCoordinatorDelegate?
    
    let window: UIWindow
    
    let tabBarController: UITabBarController
    
    init(window: UIWindow, tabBarController: UITabBarController) {
        
        self.window = window
        
        self.tabBarController = tabBarController
    }
    
    func start() {
        
        let homeVC = HomeViewController.instantiate(name: .home)
        
        homeVC.viewModel = HomeViewModel()
        
        homeVC.coordinator = self
        
        navController.viewControllers.append(homeVC)
        
        navController.tabBarItem = UITabBarItem(title: nil,
                                                image: .home,
                                                selectedImage: .home)
                
        navController.tabBarItem.imageInsets = .stEdgeInsets
        
        tabBarController.viewControllers = [navController]
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
}

extension HomeCoordinator: HomeVCCoordinatorDelegate {
    
    func showGroupListFrom(_ viewController: STBaseViewController) {
        
        let groupListVC = GroupListViewController.instantiate(name: .group)
        
        window.rootViewController?.present(groupListVC, animated: true, completion: nil)
    }
    
    func showEditGroupFrom(_ viewController: STBaseViewController) {
        
        let navigationController = STNavigationController()

        let nextVC = GroupViewController.instantiate(name: .group)

        nextVC.showType = .edit

        navigationController.viewControllers = [nextVC]

        window.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
}

extension HomeCoordinator: ExpenseVCCoordinatorDelegate {
    
    func showDetailExpenseFrom(_ viewController: STBaseViewController, expense: Expense) {

        let nextVC = ExpenseDetailViewController.instantiate(name: .home)

        nextVC.expense = expense

        navController.pushViewController(nextVC, animated: true)
    }
}

extension HomeCoordinator: NoteVCCoordinatorDelegate {
    
    func addNoteFrom(_ viewController: STBaseViewController) {
    }
}
