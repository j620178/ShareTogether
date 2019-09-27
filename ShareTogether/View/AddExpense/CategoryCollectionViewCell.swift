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
    
    func setupImage(image: UIImage, isSelected: Bool) {
        categoryImageView.image = image
        if isSelected {
            contentView.backgroundColor = .STTintColor
        } else {
            contentView.backgroundColor = UIColor.STTintColor.withAlphaComponent(0.25)
        }
        categoryImageView.alpha = 1
        categoryLabel.alpha = 0
    }
    
    func setupText(text: String, isSelected: Bool) {
        categoryLabel.text = text
        
        if isSelected {
            contentView.backgroundColor = .STTintColor
            categoryLabel.textColor = .white
        } else {
            contentView.backgroundColor = UIColor.STTintColor.withAlphaComponent(0.25)
            categoryLabel.textColor = .STTintColor
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
