//
//  HomeCoordinator.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/5.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol MainTabBarCoordinatorDelegate: AnyObject {
    
    func didFinishFrom(_ coordinator: MainTabBarCoordinator)
}

class MainTabBarCoordinator: Coordinator {
    
    private var childCoordinators = [Coordinator]()
    
    weak var delegate: MainTabBarCoordinatorDelegate?
    
    let window: UIWindow
    
    init(window: UIWindow) {
        
        self.window = window
    }
    
    func start() {
        
        guard let mainTabBarController = UIStoryboard.main.instantiateInitialViewController()
            as? STTabBarController else { return }
            
        mainTabBarController.coordinator = self
         
        window.rootViewController = mainTabBarController
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

extension MainTabBarCoordinator: STTabBarCoordinatorDelegate {
    
    func setupHomeFrom(_ tabBarController: STTabBarController) {
        
        let homeCoordinator = HomeCoordinator(window: window,
                                              tabBarController: tabBarController)
        
        addChildCoordinator(homeCoordinator)
        
        homeCoordinator.start()
    }
    
    func setupSearchExpenseFrom(_ tabBarController: STTabBarController) {
    
        let searchVC = SearchViewController.instantiate(name: .search)
         
        searchVC.viewModel = SearchViewModel()
         
        //searchVC.coordinator = self
                  
        searchVC.tabBarItem = UITabBarItem(title: nil,
                                           image: .search,
                                           selectedImage: .search)
         
        searchVC.tabBarItem.imageInsets = .stEdgeInsets
         
        tabBarController.viewControllers?.append(searchVC)
    }
    
    func setupAddExpenseFrom(_ tabBarController: STTabBarController) {
    
        let addExpenseVC = AddExpenseViewController.instantiate(name: .expense)
        
        addExpenseVC.tabBarItem = UITabBarItem(title: nil,
                                               image: .add,
                                               selectedImage: .add)
        
        addExpenseVC.tabBarItem.imageInsets = .stEdgeInsets
        
        tabBarController.viewControllers?.append(addExpenseVC)
    }
    
    func setupActivityFrom(_ tabBarController: STTabBarController) {
        
        let navController = STNavigationController()
        
        let activityVC = ActivityViewController.instantiate(name: .activity)
        
        navController.viewControllers.append(activityVC)
        
        navController.tabBarItem = UITabBarItem(title: nil,
                                               image: .notification,
                                               selectedImage: .notification)
        
        navController.tabBarItem.imageInsets = .stEdgeInsets
        
        tabBarController.viewControllers?.append(navController)
    }
    
    func setupSettingFrom(_ tabBarController: STTabBarController) {
        
        let settingVC = SettingViewController.instantiate(name: .setting)
        
        settingVC.tabBarItem = UITabBarItem(title: nil,
                                               image: .setting,
                                               selectedImage: .setting)
        
        settingVC.tabBarItem.imageInsets = .stEdgeInsets
        
        tabBarController.viewControllers?.append(settingVC)
    }
    
    func showAddExpenseFrom(_ tabBarController: STTabBarController) {
        
        let navController = STNavigationController()

        let addExpenseVC = AddExpenseViewController.instantiate(name: .expense)
        
        navController.viewControllers.append(addExpenseVC)
        
        navController.modalPresentationStyle = .overFullScreen
        
        window.rootViewController?.present(navController, animated: true, completion: nil)
    }
    
    func showSettingFrom(_ tabBarController: STTabBarController) {
        
        let settingVC = SettingViewController.instantiate(name: .setting)
        
        settingVC.modalPresentationStyle = .overFullScreen
        
        window.rootViewController?.present(settingVC, animated: false, completion: nil)
    }
}

