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

//        self.navigationBar.backIndicatorImage = .getIcon(
//            code: "ios-arrow-back",
//            color: .STDarkGray,
//            backgroundColor: .red,
//            size: 40
//        )
        
//        self.navigationBar.backIndicatorTransitionMaskImage = .getIcon(
//            code: "ios-arrow-back",
//            color: .STDarkGray,
//            backgroundColor: .red,
//            size: 40
//        )
    }

}
