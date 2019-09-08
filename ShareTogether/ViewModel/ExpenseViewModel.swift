//
//  ExpenseRecodeViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

class ExpenseViewModel: NSObject {
    
    let expense = [["機票","36,000","2018/9/4"],["租車","16,000","2018/8/27"],["門票","2,000","2018/8/27"],["Pass","6,000","2018/8/27"],["地鐵","300","2018/8/27"]]
    
    private var expenseRecodes = [ExpenseRecode]()
    
    private var cellViewModels: [ExpenseRecodeCellViewModel] = [ExpenseRecodeCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var reloadTableViewClosure: (() -> Void)?
    
    var passOffset: ((CGFloat) -> Void)?
    
    func createCellViewModel(expenseRecode: ExpenseRecode) -> ExpenseRecodeCellViewModel {
    
        return ExpenseRecodeCellViewModel( titleText: expenseRecode.title,
                                       timeText: expenseRecode.time,
                                       imageUrl: expenseRecode.userImg,
                                       amountText: "\(expenseRecode.amount)")
    }
    
    private func processFetchedRecodes(expenseRecodes: [ExpenseRecode]) {
        self.expenseRecodes = expenseRecodes // Cache
        var vms = [ExpenseRecodeCellViewModel]()
        for recode in expenseRecodes {
            vms.append(createCellViewModel(expenseRecode: recode) )
        }
        self.cellViewModels = vms
    }

}

extension ExpenseViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "今天" : "8月27日"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.identifer, for: indexPath)
        
        guard let recodeCell = cell as? ExpenseTableViewCell else { return cell }
        recodeCell.expenseTypeImageView.backgroundColor = .white
        
        recodeCell.updateContent(
            expenseType: .getIcon(code: "ios-car", color: .STTintColor, size: 60),
            userImage: nil,
            title: expense[indexPath.row][0],
            amount: expense[indexPath.row][1],
            time: expense[indexPath.row][2]
        )
        
        if indexPath.row == 0 {
            recodeCell.setupFirstCellLayout()
        } else if (indexPath.section == 0 && indexPath.row == 4) || (indexPath.section == 1 && indexPath.row == 6) {
            recodeCell.setupLastCellLayout()
        } else {
            recodeCell.resetLayout()
        }
        
        return recodeCell
    }
    
}

extension ExpenseViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        passOffset?(scrollView.contentOffset.y)
        
    }
    
}

struct ExpenseRecodeCellViewModel {
    let titleText: String
    let timeText: String
    let imageUrl: String
    let amountText: String
}
