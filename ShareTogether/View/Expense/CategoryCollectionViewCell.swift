//
//  CategoryCollectionViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupImage(image: UIImage, color: UIColor) {
        categoryImageView.image = image
        if color == .white {
            contentView.backgroundColor = .whiteAlphaOf(0.2)
        } else {
            contentView.backgroundColor = .white
        }
        categoryImageView.alpha = 1
        categoryLabel.alpha = 0
    }
    
    func setupText(text: String, color: UIColor) {
        categoryLabel.text = text
        
        if color == .white {
            contentView.backgroundColor = .whiteAlphaOf(0.2)
            categoryLabel.textColor = .white
        } else {
            contentView.backgroundColor = .white
            categoryLabel.textColor = .STBlack
        }
        categoryImageView.alpha = 0
        categoryLabel.alpha = 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBase()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBase()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func setupBase() {
        contentView.addSubview(categoryImageView)
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            categoryImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            categoryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            categoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            categoryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.cornerRadius = contentView.frame.height / 2
    }
    
}
