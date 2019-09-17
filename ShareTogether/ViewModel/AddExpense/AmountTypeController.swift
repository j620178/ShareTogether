//
//  AmountTypeController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class AmountTypeController: NSObject, AddExpenseItem {
    
    var tableView: UITableView
    
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
    
    var amountTypeIndex = 0
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.registerWithNib(indentifer: SelectionTableViewCell.identifer)
    }
    
}

extension AmountTypeController: UITableViewDelegate {
    
}

extension AmountTypeController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.identifer, for: indexPath)
        
        guard let selectionCell = cell as? SelectionTableViewCell else { return cell }
        
        selectionCell.collectionView.delegate = self
        
        selectionCell.collectionView.dataSource = self
        
        selectionCell.collectionView.reloadData()
        
        return selectionCell
    }
    
}

extension AmountTypeController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return expenseTypeData.count

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifer,
            for: indexPath)
        
        guard let categoryCell = cell as? CategoryCollectionViewCell else { return cell }

        if expenseTypeData[indexPath.row].isSelect {
            categoryCell.setupImage(image: expenseTypeData[indexPath.row].data.getImage(color: .white),
                                    isSelected: expenseTypeData[indexPath.row].isSelect)
        } else {
            categoryCell.setupImage(image: expenseTypeData[indexPath.row].data.getImage(color: .STTintColor),
                                    isSelected: expenseTypeData[indexPath.row].isSelect)
        }

        return categoryCell
    }
    
}

extension AmountTypeController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        amountTypeIndex = indexPath.row
    
        for index in expenseTypeData.indices {
            expenseTypeData[index].isSelect = false
            if index == indexPath.row {
                expenseTypeData[index].isSelect = true
            }
        }
        
        collectionView.reloadData()
        
    }
    
}
