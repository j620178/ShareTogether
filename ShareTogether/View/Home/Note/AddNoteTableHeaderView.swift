//
//  AddNoteTableHeaderView.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/26.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class AddNoteTableHeaderView: UITableViewHeaderFooterView {

    let addNoteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("想留下些什麼嗎？", for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.25), for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        return button
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.image = .user
        return imageView
    }()
    
    var clickHeaderViewHandler: (() -> Void)?
    
    @objc func clickButton() {
        clickHeaderViewHandler?()
    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(addNoteButton)
        contentView.addSubview(userImageView)
        
        let userImageViewBottomConstant = userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        let addNoteButtonTrailingConstant = addNoteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            userImageView.heightAnchor.constraint(equalToConstant: 30),
            userImageView.widthAnchor.constraint(equalToConstant: 30),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userImageViewBottomConstant,
            
            addNoteButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            addNoteButton.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8),
            addNoteButtonTrailingConstant
            
        ])
        
        addNoteButtonTrailingConstant.priority = UILayoutPriority(999)
        userImageViewBottomConstant.priority = UILayoutPriority(999)
    }
    
    override init(reuseIdentifier: String?) {
         super.init(reuseIdentifier: reuseIdentifier)
         
         setupUI()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         
         setupUI()
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         
         userImageView.layer.cornerRadius = userImageView.frame.height / 2
     }
    
}
