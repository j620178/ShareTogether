//
//  STBaseViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class STBaseViewController: UIViewController {
    
    static var identifier: String {
        
        return String(describing: self)
    }
    
    var isHideNavigationBar: Bool {
        
        return false
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

}
