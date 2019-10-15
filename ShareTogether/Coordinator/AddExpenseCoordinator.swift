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
    
    var expense: Expense?
    
    init(window: UIWindow, expense: Expense?) {
        
        self.window = window
        
        super.init()
    }
    
    func start() {
        
        let addExpenseVC = AddExpenseViewController.instantiate(name: .expense)
        
        addExpenseVC.coordinator = self
        
        addExpenseVC.viewModel = AddExpenseViewModel()

        navigationController.viewControllers.append(addExpenseVC)

        navigationController.modalPresentationStyle = .overFullScreen

        window.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
}

extension AddExpenseCoordinator: AddExpenseVCCoordinatorDelegate {
    
    func didFinishAddExpense(_ viewController: STBaseViewController) {
        
        navigationController.dismiss(animated: true, completion: nil)
        
        delegate?.didFinishAddFrom(self)
    }
    
    func showCalculatorViewController(_ viewController: STBaseViewController,
                                      amount: Double,
                                      splitInfo: AmountInfo?) {
                
        let calculatorVC = CalculatorViewController.instantiate(name: .expense)
        
        calculatorVC.coordinator = self

        calculatorVC.amount = amount

        calculatorVC.splitInfo = splitInfo

        navigationController.pushViewController(calculatorVC, animated: true)
    }
    
    func dismiss(_ viewController: STBaseViewController) {
        
        navigationController.dismiss(animated: true, completion: nil)
        
        delegate?.didFinishAddFrom(self)
    }
}

extension AddExpenseCoordinator: CalculatorVCCoordinatorDelegate {
    
    func didFinishCalculateFrom(_ viewController: STBaseViewController, splitInfo: AmountInfo) {
        
        for viewController in navigationController.viewControllers {

            if let previousVC = viewController as? AddExpenseViewController {
                
                previousVC.splitController.splitInfo = splitInfo
            }
        }
        
        navigationController.popViewController(animated: true)
    }
}
