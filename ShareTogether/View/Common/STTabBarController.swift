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
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
        case .home: controller = UIStoryboard.home.instantiateInitialViewController()!
            
        case .search: controller = UIStoryboard.search.instantiateInitialViewController()!

        case .expense: controller = UIStoryboard.expense.instantiateInitialViewController()!
            
        case .activity: controller = UIStoryboard.activity.instantiateInitialViewController()!
            
        case .setting: controller = UIStoryboard.menu.instantiateInitialViewController()!
            
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
            
        case .search:
            return UITabBarItem(
                title: nil,
                image: .search,
                selectedImage: .search
            )
        
        case .expense:
            return UITabBarItem(
                title: nil,
                image: .add,
                selectedImage: .add
            )
            
        case .activity:
            return UITabBarItem(
                title: nil,
                image: .notification,
                selectedImage: .notification
            )
    
        case .setting:
            return UITabBarItem(
                title: nil,
                image: .setting,
                selectedImage: .setting
            )
        }
        
    }
}

class STTabBarController: UITabBarController {
    
    private let tabs: [Tab] = [.home, .search, .expense, .activity, .setting]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        
        //TuPu
        let lineView = UIView(frame: CGRect(x: 0, y: -1, width: UIScreen.main.bounds.width, height: 1))
        lineView.backgroundColor = UIColor.white
        tabBar.addSubview(lineView)
        
        delegate = self

        viewControllers = tabs.map({ $0.controller() })
        
        tabBar.tintColor = .STDarkGray
        tabBar.addShadow()
        
    }
}

extension STTabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.isKind(of: UINavigationController.self),
            viewController.children[0] is AddExpenseViewController {
            let nextVC = UIStoryboard.expense.instantiateInitialViewController()!
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true, completion: nil)
            
            return false
            
        } else if viewController.isKind(of: ModallyMeauViewController.self) {
            
            guard let nextVC = UIStoryboard.menu.instantiateInitialViewController()!
                as? ModallyMeauViewController
            else { return false }
            
            nextVC.modalPresentationStyle = .overCurrentContext
            let view = UIView(frame: UIScreen.main.bounds)
            view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            nextVC.backgroundview = view
            self.view.addSubview(view)
            
            self.present(nextVC, animated: true, completion: nil)
            
            return false
        }
        
        return true
        
    }
}
