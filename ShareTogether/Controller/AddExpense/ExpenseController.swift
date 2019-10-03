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
    
//    var getTextFieldInfo: [String] {
//
//        var expenseInfo = ["", ""]
//
//        for index in textfieldPlaceHolder.indices {
//
//            guard let textFieldCell = tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? TextFieldTableViewCell,
//                let text = textFieldCell.textField.text
//            else { return expenseInfo }
//
//            textFieldCell.textField.resignFirstResponder()
//
//            expenseInfo[index] = text
//
//        }
//
//        return expenseInfo
//
//    }
    
    func resignAllTextField() {
        
        for index in textfieldPlaceHolder.indices {
            
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 1)),
                let textFieldCell = cell as? TextFieldTableViewCell
            else { return }
            
            textFieldCell.textField.resignFirstResponder()

        }
        
    }
    
    init(tableView: UITableView) {
        
        self.tableView = tableView
        
        self.tableView.registerWithNib(indentifer: TextFieldTableViewCell.identifer)
        
    }
    
}

extension ExpenseController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textfieldPlaceHolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifer, for: indexPath)
        
        guard let textFieldCell = cell as? TextFieldTableViewCell else { return cell }
        
        textFieldCell.textField.text = expenseInfo[indexPath.row]
        
        textFieldCell.delegate = self
        
        textFieldCell.textField.placeholder = textfieldPlaceHolder[indexPath.row]
        
        if indexPath.row == 0 {
            
            textFieldCell.textField.keyboardType = .numberPad
            
        }
        
        return textFieldCell
    }
    
}

extension ExpenseController: TextFieldTableViewCellDelegate {
    
    func didBeginEditing(cell: TextFieldTableViewCell) {
        delegate?.keyboardBeginEditing(controller: self)
    }
    
    func didEndEditing(cell: TextFieldTableViewCell, text: String?) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        expenseInfo[indexPath.row] = text ?? ""
    
    }
    
}
