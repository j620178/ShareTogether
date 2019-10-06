//
//  HomeCoordinator.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/5.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import SafariServices

protocol MainTabBarCoordinatorDelegate: AnyObject {
    
    func didFinishFrom(_ coordinator: MainTabBarCoordinator)
}

class MainTabBarCoordinator: NSObject, Coordinator {
    
    private var childCoordinators = [Coordinator]()
    
    weak var coordinator: MainTabBarCoordinatorDelegate?
    
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
        
        settingVC.coordinator = self
        
        settingVC.modalPresentationStyle = .overFullScreen
        
        window.rootViewController?.present(settingVC, animated: false, completion: nil)
    }
}

extension MainTabBarCoordinator: SettingVCCoordinatorDelegate {
    
    func showPrivateInfofrom(_ viewController: STBaseViewController) {

        guard let url = URL(string: "https://www.privacypolicies.com/privacy/view/e9b6b5e82a15d74909eff1e0d8234312")
        else { return }

        let safariVC = SFSafariViewController(url: url)

        safariVC.delegate = self

        viewController.present(safariVC, animated: true, completion: nil)
    }
    
    func didLogoutFrom(_ viewController: STBaseViewController) {
        
        AuthManager.shared.signOut()
        
        CurrentManager.shared.removeCurrentUser()
        
        CurrentManager.shared.removeCurrentGroup()
        
        coordinator?.didFinishFrom(self)
        
    }
    
    func didCancel(_ viewController: STBaseViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension MainTabBarCoordinator: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {

        controller.dismiss(animated: true, completion: nil)
    }
}
