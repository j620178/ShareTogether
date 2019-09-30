//
//  PayerController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol PayerControllerDelegate: AnyObject {
    func didSelectPayTypeAt(_ indexPath: IndexPath)
}

class PayerController: NSObject, AddExpenseItem {
    
    var tableView: UITableView

    weak var delegate: PayerControllerDelegate? {
       didSet {
           initPayInfo()
       }
    }
    
    var payInfo: AmountInfo? {
        didSet {
            tableView.reloadData()
        }
    }

    func initPayInfo() {
        let members = CurrentInfoManager.shared.availableMembers
                
        if payInfo == nil, members.count > 0 {
            var payInfo = AmountInfo(type: SplitType.average.rawValue, amountDesc: [AmountDesc]())
            for index in members.indices {
                if index == 0 {
                    payInfo.amountDesc.append(AmountDesc(member: members[index], value: 1))
                } else {
                    payInfo.amountDesc.append(AmountDesc(member: members[index], value: nil))
                }
            }
            self.payInfo = payInfo
        }
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.registerWithNib(indentifer: SplitTableViewCell.identifer)
    }

}

extension PayerController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.didSelectPayTypeAt(indexPath)

    }
    
}

extension PayerController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SplitTableViewCell.identifer, for: indexPath)
        
        guard let splitCell = cell as? SplitTableViewCell,
            let payInfo = payInfo
        else { return cell }
        
        for amountDesc in payInfo.amountDesc where amountDesc.value != nil {
            splitCell.setupContent(title: "1 人支付", type: amountDesc.member.name)
        }
        
        return splitCell
        
    }
    
}
