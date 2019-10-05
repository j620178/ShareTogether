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

    var window: UIWindow
    
    private var coordinators = [Coordinator]()
    
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

    func addCoordinator(coordinator: Coordinator) {
        coordinators.append(coordinator)
    }
    
    func removeCoordinator(coordinator: Coordinator) {
        coordinators = coordinators.filter { $0 !== coordinator }
    }
    
}

extension AppCoordinator: LoginCoordinatorDelegate {
    
    func showLogin() {
        let loginCoordinator = LoginCoordinator(window: window)
        addCoordinator(coordinator: loginCoordinator)
        loginCoordinator.delegate = self
        loginCoordinator.start()
    }
    
    func didFinishBy(coordinator: LoginCoordinator) {
        
        removeCoordinator(coordinator: coordinator)
        
    }

}

extension AppCoordinator: HomeCoordinatorDelegate {
    
    func showHome() {
        let homeCoordinator = HomeCoordinator(window: window)
        addCoordinator(coordinator: homeCoordinator)
        homeCoordinator.delegate = self
        homeCoordinator.start()
    }
    
    func didFinishBy(coordinator: HomeCoordinator) {
        removeCoordinator(coordinator: coordinator)
    }
    

}
