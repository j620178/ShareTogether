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
    
    weak var delegate: PayerControllerDelegate?
    
    var members = [MemberInfo]() {
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
        
        if payInfo == nil {
            payInfo = AmountInfo(type: SplitType.average.rawValue, amountDesc: [AmountDesc]())
            var index = 0
            for member in members {
                if index == 0 {
                    payInfo?.amountDesc.append(AmountDesc(member: member, value: 1))
                } else {
                    payInfo?.amountDesc.append(AmountDesc(member: member, value: nil))
                }
                index += 1
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
        
        for amount in payInfo.amountDesc where amount.value != nil {
            splitCell.setupContent(title: amount.member.name, type: "")
        }
        
        return splitCell
        
    }
    
}
