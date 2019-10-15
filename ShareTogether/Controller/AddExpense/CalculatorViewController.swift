//
//  SplitViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/9.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol CalculatorVCCoordinatorDelegate: AnyObject {
    
    func didFinishCalculateFrom(_ viewController: STBaseViewController, splitInfo: AmountInfo)
}

class CalculatorViewController: STBaseViewController {
    
    var coordinator: CalculatorVCCoordinatorDelegate?
    
    let selectionViewTitle = ["均分", "比例", "指定金額"]
        
    var amount: Double?
    
    var splitInfo: AmountInfo?
    
    @IBOutlet weak var selectionView: SelectionView! {
        didSet {
            selectionView.dataSource = self
            selectionView.delegate = self
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerWithNib(identifier: CheckBoxTableViewCell.identifier)
            tableView.registerWithNib(identifier: SplitTextFieldTableViewCell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        title = "選擇分帳方式"
        
        let barItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(saveDate(_:)))
            
        navigationItem.rightBarButtonItem = barItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectionView.setIndicatorPosition(index: splitInfo?.type ?? 0)
    }
    
    @objc func saveDate(_ sender: UIBarButtonItem) {
    
        guard let splitInfo = splitInfo else { return }
        
        if isSaveAvailable(splitInfo: splitInfo) {
            
            coordinator?.didFinishCalculateFrom(self, splitInfo: splitInfo)
            
        } else {
            
            LKProgressHUD.showFailure(text: "輸入數值異常", view: self.view)
        }
    }
    
    func isSaveAvailable(splitInfo: AmountInfo) -> Bool {
        
        guard let amount = amount else { return false }
        
        var result: Double = 0
        
        if SplitType(rawValue: splitInfo.type) == SplitType.percentage {
            
            for aAmountDesc in splitInfo.amountDesc {
                
                result += aAmountDesc.value ?? 0
                
            }
            
            return result == 100.0 ? true : false
            
        } else if SplitType(rawValue: splitInfo.type) == SplitType.amount {
            
            for aAmountDesc in splitInfo.amountDesc {
                
                result += aAmountDesc.value ?? 0
                
            }

            return result == amount ? true : false
        }
        
        return true
    }
}

extension CalculatorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return splitInfo?.amountDesc.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectionView.currentIndex == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifier, for: indexPath)
    
            guard let checkBoxCell = cell as? CheckBoxTableViewCell,
                let splitInfo = splitInfo else { return cell }
    
            checkBoxCell.setupContent(name: splitInfo.amountDesc[indexPath.row].member.name,
                                      photoURL: splitInfo.amountDesc[indexPath.row].member.photoURL)
           
            if splitInfo.amountDesc[indexPath.row].value != nil {
                
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                
            } else {
                
                tableView.deselectRow(at: indexPath, animated: true)
                
            }
            
            return checkBoxCell
            
        } else if selectionView.currentIndex == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SplitTextFieldTableViewCell.identifier,
                for: indexPath)
            
            guard let textFieldCell = cell as? SplitTextFieldTableViewCell,
                let splitInfo = splitInfo else { return cell }
                        
            textFieldCell.delegate = self
                        
            textFieldCell.setupContent(text: splitInfo.amountDesc[indexPath.row].value?.toText ?? "",
                                       name: splitInfo.amountDesc[indexPath.row].member.name,
                                       photoURL: splitInfo.amountDesc[indexPath.row].member.photoURL,
                                       unit: "%")
            
            return textFieldCell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SplitTextFieldTableViewCell.identifier,
                for: indexPath)
            
            guard let textFieldCell = cell as? SplitTextFieldTableViewCell,
                let splitInfo = splitInfo else { return cell }
            
            textFieldCell.delegate = self
            
            textFieldCell.setupContent(text: splitInfo.amountDesc[indexPath.row].value?.toText ?? "",
                                       name: splitInfo.amountDesc[indexPath.row].member.name,
                                       photoURL: splitInfo.amountDesc[indexPath.row].member.photoURL,
                                       unit: "元")
        
            return textFieldCell
        }
    }
}

extension CalculatorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        splitInfo?.amountDesc[indexPath.row].value = 1
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        splitInfo?.amountDesc[indexPath.row].value = nil
    }
}

extension CalculatorViewController: SelectionViewDataSource {
    
    func titleOfRowAt(selectionView: SelectionView, index: Int) -> String {
        
        return selectionViewTitle[index]
    }
    
    func numberOfSelectionButtons(selectionView: SelectionView) -> Int {
        
        return selectionViewTitle.count
    }
    
    func indicatorColorOfSelectionButtons(selectionView: SelectionView) -> UIColor {
        
        return .STTintColor
    }
    
    func titleColorOfSelectionButtons(selectionView: SelectionView, index: Int) -> UIColor {
        
        return .STTintColor
    }
    
    func backgroundColorOfSelectionButtons(selectionView: SelectionView, index: Int) -> UIColor {
        
        return .white
    }
    
    func fontOfSelectionButtons(selectionView: SelectionView, index: Int) -> UIFont {
        
        return .systemFont(ofSize: 15, weight: .bold)
    }
}

extension CalculatorViewController: SelectionViewDelegate {
    
    func didSelectButton(selectionView: SelectionView, index: Int) {
        
        guard let splitInfo = splitInfo, let type = SplitType(rawValue: index) else { return }
        
        self.splitInfo?.type = type.rawValue
        
        for index in splitInfo.amountDesc.indices {
            
            if type == .average {
                
                self.splitInfo?.amountDesc[index].value = 1
                
            } else {
                
                self.splitInfo?.amountDesc[index].value = nil
                
            }
        }
        
        tableView.reloadData()
    }
}

extension CalculatorViewController: SplitTextFieldCellDelegate {
    
    func splitTextFieldTableViewCell(cell: SplitTextFieldTableViewCell, didChangeText: String) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
                
        splitInfo?.amountDesc[indexPath.row].value = Double(didChangeText) 
    }
}

extension CalculatorViewController: CheckBoxTableViewCellDelegate {
    
    func checkBoxTableViewCell(cell: CheckBoxTableViewCell, isSelectedDidChange: Bool) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        if isSelectedDidChange {
            
            splitInfo?.amountDesc[indexPath.row].value = 1
            
        } else {
            
            splitInfo?.amountDesc[indexPath.row].value = nil
        }
    }
}
