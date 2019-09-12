//
//  SplitViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/9.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class SplitViewController: STBaseViewController {
    
    let selectionViewTitle = ["均分", "比例", "金額"]
    
    let splitUser = ["Pony", "Kevin", "Nick", "Angle", "Daniel"]
    
    @IBOutlet weak var selectionView: SelectionView! {
        didSet {
            selectionView.dataSource = self
            selectionView.delegate = self
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.registerWithNib(indentifer: CheckBoxTableViewCell.identifer)
            tableView.registerWithNib(indentifer: SplitTextFieldTableViewCell.identifer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "分帳方式"
        
        let barItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = barItem
    }
    
}

extension SplitViewController: SelectionViewDataSource {
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

extension SplitViewController: SelectionViewDelegate {
    
    func didSelectButton(selectionView: SelectionView, index: Int) {
        print(selectionView.currentIndex)
        tableView.reloadData()
    }
    
}

extension SplitViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splitUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectionView.currentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifer, for: indexPath)
    
            guard let checkBoxCell = cell as? CheckBoxTableViewCell else { return cell }
            
            checkBoxCell.userNameLabel.text = splitUser[indexPath.row]
    
            checkBoxCell.updateCheckBoxImage(isSelectd: true)
            return checkBoxCell
        } else if selectionView.currentIndex == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SplitTextFieldTableViewCell.identifer,
                for: indexPath)
            
            guard let textFieldCell = cell as? SplitTextFieldTableViewCell else { return cell }
            textFieldCell.unitLabel.text = "%"
            textFieldCell.userNameLabel.text = splitUser[indexPath.row]
            
            return textFieldCell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SplitTextFieldTableViewCell.identifer,
                for: indexPath)
            
            guard let textFieldCell = cell as? SplitTextFieldTableViewCell else { return cell }
            textFieldCell.unitLabel.text = "元"
            textFieldCell.userNameLabel.text = splitUser[indexPath.row]
            
            return textFieldCell
        }
    
    }

}
