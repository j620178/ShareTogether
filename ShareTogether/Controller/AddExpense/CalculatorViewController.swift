//
//  SplitViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/9.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct AmountInfo: Codable {
    var type: Int
    var amountDesc: [AmountDesc]
    
    func getAmount(amount: Double, index: Int) -> Double {
        if self.type == 0 {
            return amount / Double(amountDesc.count)
        } else if self.type == 1 {
            if let value = amountDesc[index].value {
                return amount * value / 100
            } else {
                return 0
            }
        } else {
            if let value = amountDesc[index].value {
                return value
            } else {
                return 0
            }
        }
    }
    
    func getPayer() -> String? {
        for aAmountDesc in amountDesc where aAmountDesc.value != nil {
            return aAmountDesc.member.id
        }
        return nil
    }
}

struct AmountDesc: Codable {
    let member: MemberInfo
    var value: Double?
}

class CalculatorViewController: STBaseViewController {
    
    let selectionViewTitle = ["均分", "比例", "指定金額"]
        
    var amount: Double?
    
    var splitInfo: AmountInfo?
    
    var passCalculateDateHandler: ((AmountInfo) -> Void)?

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
            tableView.registerWithNib(indentifer: CheckBoxTableViewCell.identifer)
            tableView.registerWithNib(indentifer: SplitTextFieldTableViewCell.identifer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "分帳方式選擇"
        
        let barItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(saveDate(_:)))
            
        navigationItem.rightBarButtonItem = barItem

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectionView.setIndicatorPosition(index: splitInfo?.type ?? 0)
    }
    
    @objc func saveDate(_ sender: UIBarButtonItem) {
    
        guard var splitInfo = splitInfo else { return }
        
        for index in splitInfo.amountDesc.indices {
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)),
                let textfieldCell = cell as? SplitTextFieldTableViewCell,
                let text = textfieldCell.textField.text
            else { return }
            
            if let number = Double(text) {
                splitInfo.amountDesc[index].value = number
            } else {
                splitInfo.amountDesc[index].value = 0
            }
            
        }
        
        if isSaveAvailable(splitInfo: splitInfo) {
            passCalculateDateHandler?(splitInfo)
            navigationController?.popViewController(animated: true)
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
        
        guard let splitInfo = splitInfo else { return UITableViewCell() }
        
        if selectionView.currentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifer, for: indexPath)
    
            guard let checkBoxCell = cell as? CheckBoxTableViewCell else { return cell }
    
            checkBoxCell.setupContent(name: splitInfo.amountDesc[indexPath.row].member.name,
                                      photoURL: splitInfo.amountDesc[indexPath.row].member.photoURL)
           
            if splitInfo.amountDesc[indexPath.row].value != nil {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
            
            return checkBoxCell
            
        } else if selectionView.currentIndex == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SplitTextFieldTableViewCell.identifer,
                for: indexPath)
            
            guard let textFieldCell = cell as? SplitTextFieldTableViewCell else { return cell }
            textFieldCell.setupContent(text: splitInfo.amountDesc[indexPath.row].value == nil ? "" : String(splitInfo.amountDesc[indexPath.row].value!),
                                       name: splitInfo.amountDesc[indexPath.row].member.name,
                                       photoURL: splitInfo.amountDesc[indexPath.row].member.photoURL,
                                       unit: "%")
            
            return textFieldCell
            
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SplitTextFieldTableViewCell.identifer,
                for: indexPath)
            
            guard let textFieldCell = cell as? SplitTextFieldTableViewCell else { return cell }
            textFieldCell.setupContent(text: splitInfo.amountDesc[indexPath.row].value == nil ? "" : String(splitInfo.amountDesc[indexPath.row].value!),
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
        
        guard let splitInfo = splitInfo, let type = SplitType(rawValue: index)  else { return }
        
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
