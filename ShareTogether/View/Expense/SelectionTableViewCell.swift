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
    
    var expenseTypeData: [(data: ExpenseType, isSelect: Bool)] = [
        (.null, true),
        (.car, false),
        (.subway, false),
        (.bicycle, false),
        (.gasStation, false),
        (.parking, false),
        (.hotel, false),
        (.bus, false),
        (.gift, false),
        (.restaurant, false),
        (.wine, false)
    ]
    
    var weekDaysData = [(day: Int, weekday: Int, isSelect: Bool)]()

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
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
            collectionView.register(
                CategoryCollectionViewCell.self,
                forCellWithReuseIdentifier: CategoryCollectionViewCell.identifer)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        createDayOfWeek()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
    }
    
    func createDayOfWeek() {
        let cal = Calendar.current
        var days = [(Int, Int, Bool)]()
        
        for index in -3...3 {
            var date = cal.startOfDay(for: Date())
            date = cal.date(byAdding: .day, value: index, to: date)!
            let day = cal.component(.day, from: date)
            let weekday = cal.component(.weekday, from: date)
            
            index == 0 ? days.append((day, weekday, true)) : days.append((day, weekday, false))
        }
        
        weekDaysData = days
    }
    
}

extension SelectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch type {
        case .image:
            return expenseTypeData.count
        case .text:
            return weekDaysData.count
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
            if expenseTypeData[indexPath.row].isSelect {
                categoryCell.setupImage(image: expenseTypeData[indexPath.row].data.getImage(color: .white),
                                        isSelected: expenseTypeData[indexPath.row].isSelect)
            } else {
                categoryCell.setupImage(image: expenseTypeData[indexPath.row].data.getImage(color: .STTintColor),
                                        isSelected: expenseTypeData[indexPath.row].isSelect)
            }
        case .text:
            if weekDaysData[indexPath.row].isSelect {
                categoryCell.setupText(text: "\(weekDaysData[indexPath.row].day)", isSelected: weekDaysData[indexPath.row].isSelect)
            } else {
                categoryCell.setupText(text: "\(weekDaysData[indexPath.row].day)", isSelected: weekDaysData[indexPath.row].isSelect)
            }

        }
        
        return categoryCell
    }
    
}

extension SelectionTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch type {
   
        case .image:
            for index in expenseTypeData.indices {
                expenseTypeData[index].isSelect = false
                if index == indexPath.row {
                    expenseTypeData[index].isSelect = true
                }
            }
            collectionView.reloadData()
        case .text:
            for index in weekDaysData.indices {
                weekDaysData[index].isSelect = false
                if index == indexPath.row {
                    weekDaysData[index].isSelect = true
                }
            }
            collectionView.reloadData()

        }
        
    }
    
}
