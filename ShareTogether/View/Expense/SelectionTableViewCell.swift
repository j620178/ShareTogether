//
//  CategoryTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/4.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {
    
    enum DataType {
        case image
        case text
    }
    
    var type = DataType.image
    
    enum CategoryType: String {
        case usd = "logo-usd"
        case car = "ios-car"
        case subway = "ios-subway"
        case bicycle = "ios-bicycle"
        case gasStation = "local.gas.station"
        case parking = "local.parking"
        case bed = "ios-bed"
        case bus = "ios-bus"
        case gift = "ios-gift"
        case shirt = "ios-shirt"
        case restaurant = "ios-restaurant"
        case wine = "ios-wine"
    }
    
    var categoryData: [CategoryType] = [.usd, .car, .subway, .bicycle, .bed, .bus, .gift, .shirt, .restaurant, .wine]
    
    var stringData: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    var selectedCategory = [true, false, false, false, false, false, false, false, false, false]
    
    var selectedString = [true, false, false, false, false, false, false, false, false]

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize(width: 60, height: 60)
            flowLayout.minimumInteritemSpacing = 5
            flowLayout.minimumLineSpacing = 5
            
            collectionView.collectionViewLayout = flowLayout
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.register(
                CategoryCollectionViewCell.self,
                forCellWithReuseIdentifier: CategoryCollectionViewCell.identifer)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
    }
    
}

extension SelectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch type {
        case .image:
            return categoryData.count
        case .text:
            return stringData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifer,
            for: indexPath)
        
        guard let categoryCell = cell as? CategoryCollectionViewCell else { return cell }
        
        switch type {
            
        case .image:
            if selectedCategory[indexPath.row] {
                categoryCell.setupImage(image:
                    .getIcon(code: categoryData[indexPath.row].rawValue, color: .white, size: 60),
                                        isSelected: selectedCategory[indexPath.row])
            } else {
                categoryCell.setupImage(image:
                    .getIcon(code: categoryData[indexPath.row].rawValue, color: .STTintColor, size: 60),
                                        isSelected: selectedCategory[indexPath.row])
            }
        case .text:
            if selectedString[indexPath.row] {
                categoryCell.setupText(text: stringData[indexPath.row], isSelected: selectedString[indexPath.row])
            } else {
                categoryCell.setupText(text: stringData[indexPath.row], isSelected: selectedString[indexPath.row])
            }

        }
        
        return categoryCell
    }
    
}

extension SelectionTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch type {
   
        case .image:
            for index in selectedCategory.indices {
                selectedCategory[index] = false
                if index == indexPath.row {
                    selectedCategory[index] = true
                }
            }
            collectionView.reloadData()
        case .text:
            for index in selectedString.indices {
                selectedString[index] = false
                if index == indexPath.row {
                    selectedString[index] = true
                }
            }
            collectionView.reloadData()

        }
        
    }
    
}
