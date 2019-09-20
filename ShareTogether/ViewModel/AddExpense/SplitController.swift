//
//  SplitUserController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

//class SplitUserController: NSObject, AddExpenseItem {
//    
//    var tableView: UITableView
//    
//    var members = [MemberInfo]() {
//        didSet {
//            processMember()
//        }
//    }
//    
//    var splitUser = [(user: MemberInfo, isSplit: Bool)]()
//
//    func processMember() {
//        var splitUser = [(MemberInfo, Bool)]()
//        for member in members {
//            splitUser.append((member, true))
//        }
//        self.splitUser = splitUser
//    }
//    
//    init(tableView: UITableView) {
//        self.tableView = tableView
//        self.tableView.registerWithNib(indentifer: CheckBoxTableViewCell.identifer)
//    }
//    
//}
//
//extension SplitUserController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        guard let cell = tableView.cellForRow(at: indexPath),
//            let checkBoxCell = cell as? CheckBoxTableViewCell else { return }
//
//        splitUser[indexPath.row].isSplit = !splitUser[indexPath.row].isSplit
//
//        checkBoxCell.setupContent(name: splitUser[indexPath.row].user.name,
//                                  photoURL: splitUser[indexPath.row].user.photoURL,
//                                  isSelectd: splitUser[indexPath.row].isSplit)
//
//    }
//    
//}
//
//extension SplitUserController: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return splitUser.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifer, for: indexPath)
//        
//        guard let checkBoxCell = cell as? CheckBoxTableViewCell else { return cell }
//        
//        checkBoxCell.setupContent(name: splitUser[indexPath.row].user.name,
//                                  photoURL: splitUser[indexPath.row].user.photoURL,
//                                  isSelectd: splitUser[indexPath.row].isSplit)
//        
//        return checkBoxCell
//    
//    }
//    
//}

enum SplitType: Int {
    case average = 0
    case percentage = 1
    case amount = 2
    
    var getString: String {
        switch self {
            
        case .average:
            return "均分"
        case .percentage:
            return "比例"
        case .amount:
            return "指定金額"
        }
    }
}

protocol SplitControllerDelegate: AnyObject {
    func didSelectSplitTypeAt(_ indexPath: IndexPath)
}

class SplitController: NSObject, AddExpenseItem {
    
    var tableView: UITableView
    
    weak var delegate: SplitControllerDelegate?
    
    var members = [MemberInfo]() {
        didSet {
            initSplitInfo()
        }
    }
    
    var splitInfo: AmountInfo? {
        didSet {
            tableView.reloadData()
            print(splitInfo)
        }
    }
    var splitDetail = [Int]()
    
    func initSplitInfo() {
        
        if splitInfo == nil {
            splitInfo = AmountInfo(type: SplitType.average.rawValue, amountDesc: [AmountDesc]())
            
            for member in members {
                splitInfo?.amountDesc.append(AmountDesc(member: member, value: 1))
            }
        } else {
            
            //guard let spliteInfo = spliteInfo else { return }
            
        }
        
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.registerWithNib(indentifer: SplitTableViewCell.identifer)
    }
    
}

extension SplitController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.didSelectSplitTypeAt(indexPath)
        
    }
    
}

extension SplitController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SplitTableViewCell.identifer, for: indexPath)
        
        guard let splitCell = cell as? SplitTableViewCell, let spliteInfo = splitInfo else { return cell }
        
        var count = 0
        
        for data in spliteInfo.amountDesc where data.value != nil {
            count += 1
        }
        
        splitCell.setupContent(title: "\(count) 名成員", type: SplitType.init(rawValue: spliteInfo.type)?.getString)
        
        return splitCell
        
    }
    
}
