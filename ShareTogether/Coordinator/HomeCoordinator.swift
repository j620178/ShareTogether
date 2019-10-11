//
//  HomeCoordinator.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/6.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import GiphyUISDK

protocol HomeCoordinatorDelegate: AnyObject {
    
    func didFinishFrom(_ coordinator: Coordinator)
}

class HomeCoordinator: NSObject, Coordinator {
    
    private var childCoordinators = [Coordinator]()
    
    let navController = STNavigationController()
    
    weak var delegate: HomeCoordinatorDelegate?
    
    let window: UIWindow
    
    let tabBarController: UITabBarController
    
    init(window: UIWindow, tabBarController: UITabBarController) {
        
        self.window = window
        
        self.tabBarController = tabBarController
    }
    
    func start() {
        
        let homeVC = HomeViewController.instantiate(name: .home)
                        
        homeVC.viewModel = HomeViewModel()
        
        homeVC.coordinator = self
        
        navController.viewControllers.append(homeVC)
        
        navController.tabBarItem = UITabBarItem(title: nil,
                                                image: .home,
                                                selectedImage: .home)
                
        navController.tabBarItem.imageInsets = .stEdgeInsets
        
        tabBarController.viewControllers = [navController]
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

extension HomeCoordinator: HomeVCCoordinatorDelegate {
    
    func showGroupListFrom(_ viewController: STBaseViewController) {
        
        let groupCoordinator = GroupCoordinator(window: window, type: .add)
        
        addChildCoordinator(groupCoordinator)
        
        groupCoordinator.start()
    }
    
    func showEditGroupFrom(_ viewController: STBaseViewController) {
        
        let groupCoordinator = GroupCoordinator(window: window, type: .edit)
        
        addChildCoordinator(groupCoordinator)
        
        groupCoordinator.start()
    }
}

extension HomeCoordinator: ExpenseVCCoordinatorDelegate {
    
    func showDetailExpenseFrom(_ viewController: STBaseViewController, expense: Expense) {

        let nextVC = ExpenseDetailViewController.instantiate(name: .home)

        nextVC.expense = expense

        navController.pushViewController(nextVC, animated: true)
    }
}

extension HomeCoordinator: NoteVCCoordinatorDelegate {
    
    func showNoteDetailFrom(_ viewController: STBaseViewController, note: Note) {
        
        let noteDetailVC = NoteDetailViewController.instantiate(name: .home)
        
        noteDetailVC.note = note
        
        noteDetailVC.coordinator = self
        
        noteDetailVC.viewModel = NoteDetailViewModel()
        
        navController.pushViewController(noteDetailVC, animated: true)
    }
    
    func addNoteFrom(_ viewController: STBaseViewController) {
        
        guard !CurrentManager.shared.isDemoGroup() else {
            LKProgressHUD.showFailure(text: "範例群組無法新增資料，請建立新群組", view: viewController.view)
            return
        }
        
        let nextVC = AddNoteViewController.instantiate(name: .home)
        
        viewController.present(nextVC, animated: true, completion: nil)
    }
}

extension HomeCoordinator: NoteDetailVCCoordinatorDelegate {
    
    func showGiphyViewControllerFrom(_ viewController: STBaseViewController) {

        let giphyVC = GiphyViewController()

        giphyVC.delegate = viewController as? NoteDetailViewController

        giphyVC.layout = .carousel
        
        viewController.present(giphyVC, animated: true, completion: nil)
    }
    
    func showDeleteAlertControllerFrom(_ viewController: STBaseViewController,
                                       noteID: String,
                                       noteCommentID: String) {
        
        let alertVC = UIAlertController.deleteAlert { _ in
    
            FirestoreManager.shared.deleteNoteComment(noteID: noteID,
                                                      noteCommentID: noteCommentID)
        }
        
        viewController.present(alertVC, animated: true, completion: nil)
    }

    func dismissGiphyViewControllerFrom(_ viewController: STBaseViewController) {
        
        viewController.dismiss(animated: true, completion: nil)
    }
}
