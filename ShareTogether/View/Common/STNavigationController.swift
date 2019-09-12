//
//  STNavigationController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class STNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = .white
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
    }

}
