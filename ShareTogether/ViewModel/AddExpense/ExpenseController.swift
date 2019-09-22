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
    
    var expenseInfo: [String?] = [nil, nil]
    
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
        
        textfieldCell.textField.delegate = self
        
        textfieldCell.textField.text = expenseInfo[indexPath.row]
        
        textfieldCell.textField.placeholder = textfieldPlaceHolder[indexPath.row]
        
        if indexPath.row == 0 {
            textfieldCell.textField.keyboardType = .numberPad
            //textfieldCell.textField.becomeFirstResponder()
        }
        
        return textfieldCell
    }
    
}

extension ExpenseController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        var superView = textField.superview
        
        while superView is UITableViewCell {
            superView = superView?.superview
        }
        
        delegate?.keyboardBeginEditing(controller: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        for index in textfieldPlaceHolder.indices {
            
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? TextFieldTableViewCell else { return }
            
            expenseInfo[index] = cell.textField.text
        }
        
    }
}
