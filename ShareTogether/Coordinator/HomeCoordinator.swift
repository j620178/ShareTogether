//
//  HomeCoordinator.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/5.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    func didFinishBy(coordinator: HomeCoordinator)
}

class HomeCoordinator: Coordinator {
    
    weak var delegate: HomeCoordinatorDelegate?
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        if let tabbarController = UIStoryboard.main.instantiateInitialViewController()
            as? STTabBarController {
            
            tabbarController.loadViewIfNeeded()
            
            guard let navController = tabbarController.viewControllers?[0] as? STNavigationController,
                let homeVC = navController.viewControllers[0] as? HomeViewController else { return }
            
            homeVC.viewModel = HomeViewModel()
             
            window.rootViewController = tabbarController
        }
 
    }
    
}
