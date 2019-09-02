//
//  AddExpenseViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/30.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var amountTextfield: UITextField!
    
    @IBOutlet weak var descTextfield: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var addExpense: UIButton!
    
    @IBAction func clickCancelButton(_ sender: UIButton) {
        if amountTextfield.isFirstResponder {
            amountTextfield.resignFirstResponder()
        } else {
            descTextfield.resignFirstResponder()
        }

        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    deinit {
        print("AE deinit")
    }
    
    func setupBase() {
        amountTextfield.layer.cornerRadius = 10.0
        amountTextfield.borderStyle = .none
        amountTextfield.clipsToBounds = true
        amountTextfield.keyboardType = .numberPad
        amountTextfield.becomeFirstResponder()
        amountTextfield.leftViewMode = .always
        amountTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        descTextfield.layer.cornerRadius = 10.0
        descTextfield.borderStyle = .none
        descTextfield.clipsToBounds = true
        descTextfield.leftViewMode = .always
        descTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        containerView.layer.cornerRadius = 20.0
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        
        //cancelButton.imageEdgeInsets = UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15)
        //cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        cancelButton.imageView?.backgroundColor = .white
        cancelButton.imageView?.layer.cornerRadius = cancelButton.imageView!.frame.height / 2
        
        //addExpense.imageEdgeInsets = UIEdgeInsets(top: 15,left: 25,bottom: 15,right: 25)
        addExpense.layer.cornerRadius = cancelButton.frame.height / 2

    }
}
