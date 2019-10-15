//
//  STTabBarController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/2.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

private enum Tab {
    
    case home
    
    case search
    
    case expense
    
    case activity
    
    case setting

}

protocol STTabBarCoordinatorDelegate: AnyObject {
    
    func setupHomeFrom(_ tabBarController: STTabBarController)
    
    func setupSearchExpenseFrom(_ tabBarController: STTabBarController)
    
    func setupAddExpenseFrom(_ tabBarController: STTabBarController)
    
    func setupActivityFrom(_ tabBarController: STTabBarController)
    
    func setupSettingFrom(_ tabBarController: STTabBarController)
    
    func showAddExpenseFrom(_ tabBarController: STTabBarController)
    
    func showSettingFrom(_ tabBarController: STTabBarController)
}

class STTabBarController: UITabBarController {
    
    weak var coordinator: STTabBarCoordinatorDelegate?
    
    private let tabs: [Tab] = [.home, .search, .expense, .activity, .setting]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        setupView()
        
        setupVC()
                
        setBadge()
    }
    
    func setupView() {
        
        UITabBar.appearance().shadowImage = UIImage()
        
        UITabBar.appearance().backgroundImage = UIImage()
        
        UITabBar.appearance().backgroundColor = UIColor.white
        
        let lineView = UIView(frame: CGRect(x: 0, y: -1, width: UIScreen.main.bounds.width, height: 1))
        
        lineView.backgroundColor = UIColor.backgroundLightGray
        
        tabBar.addSubview(lineView)
        
        tabBar.tintColor = .STDarkGray

        tabBar.unselectedItemTintColor = UIColor.black.withAlphaComponent(0.25)
    }
    
    func setupVC() {
        
        for tab in tabs {
            
            switch tab {
                
            case .home: coordinator?.setupHomeFrom(self)
                
            case .search: coordinator?.setupSearchExpenseFrom(self)

            case .expense: coordinator?.setupAddExpenseFrom(self)
                
            case .activity: coordinator?.setupActivityFrom(self)
                
            case .setting: coordinator?.setupSettingFrom(self)
            }
        }
    }
    
    func setBadge() {
        
        FirestoreManager.shared.getActivityBadge { [weak self] result in
            
            switch result {
                
            case .success(let count):
                
                if count == 0 {
                    
                    self?.viewControllers?[3].tabBarItem.badgeValue = nil
                    
                } else {
                    
                    self?.viewControllers?[3].tabBarItem.badgeValue = "\(count)"
                    
                }
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
}

extension STTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.isKind(of: AddExpenseViewController.self) {
            
            coordinator?.showAddExpenseFrom(self)
            
            return false
            
        } else if viewController.isKind(of: SettingViewController.self) {
            
            coordinator?.showSettingFrom(self)
            
            return false
        }
        
        return true
    }
}
