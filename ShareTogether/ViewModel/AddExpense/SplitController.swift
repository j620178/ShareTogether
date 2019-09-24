//
//  SplitUserController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

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
        }
    }
    var splitDetail = [Int]()
    
    func initSplitInfo() {
        
        if splitInfo == nil || splitInfo!.amountDesc.isEmpty {
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
