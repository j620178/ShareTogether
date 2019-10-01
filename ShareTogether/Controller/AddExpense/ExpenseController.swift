//
//  ExpenseController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol ExpenseTextFieldDelegate: AnyObject {
    func keyboardBeginEditing(controller: ExpenseController)
}

class ExpenseController: NSObject, AddExpenseItem {
    
    var tableView: UITableView
    
    let textfieldPlaceHolder = ["請輸入消費金額", "請輸入消費說明"]
    
    weak var delegate: ExpenseTextFieldDelegate?
    
    var expenseInfo: [String] = ["", ""]
    
    var getTextFieldInfo: [String] {
        var expenseInfo = ["", ""]
        
        for index in textfieldPlaceHolder.indices {
            guard let textFieldCell = tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? TextFieldTableViewCell,
                let text = textFieldCell.textField.text
            else { return expenseInfo }
            
            textFieldCell.textField.resignFirstResponder()
            
            expenseInfo[index] = text
        }
        
        return expenseInfo
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.registerWithNib(indentifer: TextFieldTableViewCell.identifer)
    }
    
}

extension ExpenseController: UITableViewDelegate {
    
}

extension ExpenseController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textfieldPlaceHolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifer, for: indexPath)
        
        guard let textfieldCell = cell as? TextFieldTableViewCell else { return cell }
        
        if indexPath.row == 0 {
            textfieldCell.infoPassHandler = { [weak self] text in
                self?.expenseInfo[0] = text
            }
        } else {
            textfieldCell.infoPassHandler = { [weak self] text in
                self?.expenseInfo[1] = text
            }
        }
        
        textfieldCell.didBeginEditing = { [weak self] in
            guard let strougSelf = self else { return }
            strougSelf.delegate?.keyboardBeginEditing(controller: strougSelf)
        }
        
        textfieldCell.textField.text = expenseInfo[indexPath.row]
        
        textfieldCell.textField.placeholder = textfieldPlaceHolder[indexPath.row]
        
        if indexPath.row == 0 {
            textfieldCell.textField.keyboardType = .numberPad
        }
        
        return textfieldCell
    }
    
}
