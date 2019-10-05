//
//  Kingfisher.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/15.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setUrlImage(_ urlString: String?) {
        guard let realUrlString = urlString,
            let url = URL(string: realUrlString) else { return }
        self.kf.setImage(with: url)
    }
    
}

extension UIButton {
    
    func setUrlImage(_ urlString: String, for state: UIControl.State) {
        guard let url = URL(string: urlString) else { return }
        self.kf.setImage(with: url, for: state)
    }
    
}
