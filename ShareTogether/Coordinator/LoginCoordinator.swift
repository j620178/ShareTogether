//
//  LoginCoordinator.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import SafariServices

protocol LoginCoordinatorDelegate: AnyObject {
    
    func didFinishFrom(_ coordinator: Coordinator)
}

class LoginCoordinator: NSObject, Coordinator {
    
    private var childCoordinators = [Coordinator]()
    
    var navigationController = STNavigationController()
    
    weak var delegate: LoginCoordinatorDelegate?
    
    let window: UIWindow
    
    init(window: UIWindow) {
        
        self.window = window
    }
    
    func start() {
        
        guard let loginVC = UIStoryboard.login.instantiateInitialViewController()
            as? LoginViewController else { return }
                
        loginVC.viewModel = LoginViewModel()
        
        loginVC.coordinator = self
        
        navigationController.viewControllers.append(loginVC)
        
        window.rootViewController = navigationController
    }
    
    func addCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators.append(coordinator)
    }
    
    func removeCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
}

extension LoginCoordinator: LoginViewCoordinatorDelegate {
    
    func didLoginFrom(_ viewController: UIViewController) {
        
        delegate?.didFinishFrom(self)
    }
    
    func didSignUpFrom(_ viewController: UIViewController) {
        
        let signUpVC = SignUpViewController.instantiate(name: .login)

        signUpVC.viewModel = SignUpViewModel()

        signUpVC.coordinator = self

        navigationController.pushViewController(signUpVC, animated: true)
    }

}

extension LoginCoordinator: SignUpViewCoordinatorDelegate {
    
    func showSignUpFrom(_ viewController: UIViewController) {
        
        navigationController.popViewController(animated: true)
    }
    
    func showPrivateInfoWithFrom(_ viewController: UIViewController) {
        
        guard let url = URL(string: "https://www.privacypolicies.com/privacy/view/e9b6b5e82a15d74909eff1e0d8234312")
        else { return }

        let safariVC = SFSafariViewController(url: url)

        safariVC.delegate = self

        navigationController.present(safariVC, animated: true, completion: nil)
    }

}

extension LoginCoordinator: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {

        controller.dismiss(animated: true, completion: nil)
    }
}
