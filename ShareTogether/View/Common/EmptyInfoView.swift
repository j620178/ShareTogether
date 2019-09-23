//
//  EmptyView.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/24.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class EmptyInfoView: UIView {
    
    var imageView = UIImageView()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        addSubview(imageView)
        addSubview(label)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
        imageView.image = .getIcon(code: "ios-help-circle-outline", color: .STLightYellow, size: 128)
        
        label.text = "尚無資料"
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .STDarkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    
    }
  
}
