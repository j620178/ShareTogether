//
//  AppCoordinator.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
        
    func start()
}

class AppCoordinator: Coordinator {
    
    private var childCoordinators = [Coordinator]()
    
    var window: UIWindow
    
    init(window: UIWindow) {
        
        self.window = window
    }
    
    func start() {
        
        if CurrentManager.shared.user != nil {
            
            showHome()
            
        } else {
            
            showLogin()
        }
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

extension AppCoordinator: LoginCoordinatorDelegate {
    
    func showLogin() {
        
        let loginCoordinator = LoginCoordinator(window: window)
        
        addChildCoordinator(loginCoordinator)
        
        loginCoordinator.delegate = self
        
        loginCoordinator.start()
    }
    
    func didFinishFrom(_ coordinator: Coordinator) {
        
        removeChildCoordinator(coordinator)
        
        showHome()
    }
}

extension AppCoordinator: MainTabBarCoordinatorDelegate {
    
    func showHome() {
        
        let mainTabBarCoordinator = MainTabBarCoordinator(window: window)
        
        addChildCoordinator(mainTabBarCoordinator)
        
        mainTabBarCoordinator.coordinator = self
        
        mainTabBarCoordinator.start()
    }
    
    func didFinishFrom(_ coordinator: MainTabBarCoordinator) {
        
        removeChildCoordinator(coordinator)
        
        showLogin()
    }
}
