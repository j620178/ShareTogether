//
//  STBaseViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class STBaseViewController: UIViewController {
    
    static var identifier: String {
        
        return String(describing: self)
    }
    
    static func instantiate(name: StoryboardCategory) -> Self {
        
        let storyboard = UIStoryboard(name: name.rawValue, bundle: nil)
        
        guard let baseVC = storyboard.instantiateViewController(identifier: self.identifier)
            as? Self else { fatalError() }
        
        return baseVC
    }
    
    func addChild(childController: UIViewController, to view: UIView) {
        
        self.addChild(childController)
        
        childController.view.frame = view.bounds
        
        view.addSubview(childController.view)
        
        childController.didMove(toParent: self)
    }
    
    var isHideNavigationBar: Bool {
        
        return false
    }

    var isEnableResignOnTouchOutside: Bool {
        
        return false
    }
    
    var isEnableIQKeyboard: Bool {

        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        if !isEnableIQKeyboard {
            IQKeyboardManager.shared.enable = false
        }

        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        if !isEnableIQKeyboard {
            IQKeyboardManager.shared.enable = true
        }

        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        }
        
    }

}
