//
//  ResultViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

class ResultViewModel: NSObject {
    
    let data = ["Kevin", "Nick", "Angle", "Daniel"]
    let data2 = ["3000", "200", "10000", "20330"]
    
}

extension ResultViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifer, for: indexPath)
        
        guard let resultCell = cell as? ResultTableViewCell else { return cell }
        
        resultCell.uadateContent(leftUser: data[indexPath.row], rightUser: "Pony", amount: data2[indexPath.row])
        
        return resultCell
    }
    
}

extension ResultViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
    
}
