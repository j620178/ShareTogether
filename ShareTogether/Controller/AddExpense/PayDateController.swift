//
//  PayDateController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class PayDateController: NSObject, AddExpenseItem {
    
    var tableView: UITableView
    
    var selectDate: Date?
    
    var weekDaysData = [(date: Date, isSelect: Bool)]() {
        didSet {
            for weekDay in weekDaysData where weekDay.isSelect == true {
                selectDate = weekDay.date
            }
            tableView.reloadData()
        }
    }
    
    func initDayOfWeek() {
        
        if let selectDate = selectDate {
            weekDaysData = createDayOfWeekData(startOfDay: selectDate)
        } else {
            weekDaysData = createDayOfWeekData(startOfDay: Date())
        }

    }
    
    func createDayOfWeekData(startOfDay: Date) -> [(Date, Bool)] {
        let cal = Calendar.current
        var days = [(Date, Bool)]()
        
        for index in -7...7 {
              var date = cal.startOfDay(for: startOfDay)
            date = cal.date(byAdding: .day, value: index, to: date)!
            
            index == 0 ? days.append((startOfDay, true)) : days.append((date, false))
        }
        
        return days
    }

    init(tableView: UITableView) {
        self.tableView = tableView
        tableView.registerWithNib(identifier: SelectionTableViewCell.identifier)
    }
    
}

extension PayDateController: UITableViewDelegate {
    
}

extension PayDateController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.identifier, for: indexPath)
        
        guard let selectionCell = cell as? SelectionTableViewCell else { return cell }
        
        selectionCell.collectionView.delegate = self
        
        selectionCell.collectionView.dataSource = self
        
        selectionCell.collectionView.reloadData()
        
        selectionCell.collectionView.layoutIfNeeded()
        
        selectionCell.collectionView.scrollToItem(at: IndexPath(row: 7, section: 0),
                                                  at: .centeredHorizontally,
                                                  animated: true)
        
        return selectionCell
    }
    
}

extension PayDateController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return weekDaysData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifier,
            for: indexPath)
        
        guard let categoryCell = cell as? CategoryCollectionViewCell else { return cell }
        
        if weekDaysData[indexPath.row].isSelect {
            categoryCell.setupText(text: "\(weekDaysData[indexPath.row].date.toDay)",
                isSelected: weekDaysData[indexPath.row].isSelect)
        } else {
            categoryCell.setupText(text: "\(weekDaysData[indexPath.row].date.toDay)",
                isSelected: weekDaysData[indexPath.row].isSelect)
        }
        
        return categoryCell
    }
    
}

extension PayDateController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for index in weekDaysData.indices {
            weekDaysData[index].isSelect = false
            if index == indexPath.row {
                weekDaysData[index].isSelect = true
            }
        }
        collectionView.reloadData()
    }
    
}
