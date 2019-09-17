//
//  PayerController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

enum PayType: Int {
    case onePerson = 0
    case multiplePeople = 1
    
    var getString: String {
        switch self {
            
        case .onePerson:
            return "一人"
        case .multiplePeople:
            return "多人"
        }
    }
}

struct PayDetail {
    var user: UserInfo
    var value: Double
}

protocol PayerControllerDelegate: AnyObject {
    func didSelectPayTypeAt(_ indexPath: IndexPath)
}

class PayerController: NSObject, AddExpenseItem {
    
    var tableView: UITableView
    
    weak var delegate: PayerControllerDelegate?
    
    var members = [MemberInfo]()
    
    var payer: UserInfo?
    
    var payType: PayType?
    
    var payDetail = [PayDetail]()
    
    func initData() {
        
        payer = UserInfoManager.shaered.currentUserInfo
        
        payType = .onePerson
        
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
        
        guard let splitCell = cell as? SplitTableViewCell, let payer = payer else { return cell }
        
        splitCell.setupContent(title: payer.name, type: "")
        
        return splitCell
        
    }
    
}
