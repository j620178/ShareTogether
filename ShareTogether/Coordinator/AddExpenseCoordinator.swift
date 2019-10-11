//
//  AddExpenseCoordinator.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/11.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import Foundation

protocol AddExpenseCoordinatorDelegate: AnyObject {
    
    func didFinishAddFrom(_ coordinator: AddExpenseCoordinator)
}

class AddExpenseCoordinator: NSObject, Coordinator {
    
    private var childCoordinators = [Coordinator]()
    
    var navigationController = STNavigationController()
    
    weak var delegate: AddExpenseCoordinatorDelegate?
    
    let window: UIWindow
    
    init(window: UIWindow) {
        
        self.window = window
    }
    
    func start() {
        
        let addExpenseVC = AddExpenseViewController.instantiate(name: .expense)

        navigationController.viewControllers.append(addExpenseVC)

        navigationController.modalPresentationStyle = .overFullScreen

        window.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
    
    
}
