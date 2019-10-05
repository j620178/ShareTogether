//
//  LoginCoordinator.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
    func didFinishBy(coordinator: LoginCoordinator)
}

class LoginCoordinator: Coordinator {    
    
    weak var delegate: LoginCoordinatorDelegate?
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        guard let navController = UIStoryboard.login.instantiateInitialViewController() as? STNavigationController,
            let loginVC = navController.viewControllers[0] as? LoginViewController else { return }
        
        window.rootViewController = navController
    }
    
}
