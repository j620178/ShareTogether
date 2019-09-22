//
//  StatisticsTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

struct StatisticsCellViewModel {
    let total: Double
    let count: Int
    let selfPay: Double
    let selfLend: Double
    let selfBorrow: Double
}

class StatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var insetContentView: UIView!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var expenseCountLabel: UILabel!
    
    @IBOutlet weak var selfPayLabel: UILabel!
    
    @IBOutlet weak var lendLabel: UILabel!
    
    @IBOutlet weak var borrowLabel: UILabel!
    
    var cellViewModel: StatisticsCellViewModel? {
        didSet {
            guard let cellViewModel = cellViewModel else { return }
            
            self.totalLabel.text = "\(cellViewModel.total)"
            self.expenseCountLabel.text = "\(cellViewModel.count)"
            self.selfPayLabel.text = "\(cellViewModel.selfPay)"
            self.lendLabel.text = "\(cellViewModel.selfLend)"
            self.borrowLabel.text = "\(cellViewModel.selfBorrow)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        insetContentView.addCornerRadius()
    }
    
}
