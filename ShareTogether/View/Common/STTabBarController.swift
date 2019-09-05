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
    
    case expense
    
    case activity
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
        case .home: controller = UIStoryboard.home.instantiateInitialViewController()!
            
        case .expense: controller = UIStoryboard.expense.instantiateInitialViewController()!
            
        case .activity: controller = UIStoryboard.activity.instantiateInitialViewController()!
            
        }
        
        controller.tabBarItem = tabBarItem()
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {
            
        case .home:
            let item = UITabBarItem(
                title: nil,
                image: .home,
                selectedImage: .home
            )
            item.image?.withRenderingMode(.alwaysOriginal)
            return item
            
        case .expense:
            return UITabBarItem(
                title: nil,
                image: .add,
                selectedImage: .add
            )
            
        case .activity:
            return UITabBarItem(
                title: nil,
                image: .notifications,
                selectedImage: .notifications
            )
        }
        
    }
}

class STTabBarController: UITabBarController {
    
    private let tabs: [Tab] = [.home, .expense, .activity] //, .search, .setting

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        
        viewControllers = tabs.map({ $0.controller() })
        tabBar.layer.shadowOpacity = 0.8
        tabBar.layer.shadowRadius = 3
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        
        delegate = self
        
    }
}

extension STTabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.isKind(of: UINavigationController.self) {
            
            let nextVC = UIStoryboard.expense.instantiateInitialViewController()!
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true, completion: nil)
            return false
            
        }
        
        return true
        
    }
}
