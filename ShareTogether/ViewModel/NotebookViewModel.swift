//
//  ActiveViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

class NotebookViewModel: NSObject {
    
    let data = ["Pony", "Kevin", "Nick", "Angel", "Daniel"]
    let data2 = ["Me", "恩～～～～", "我是天才!!!!", "你長大就知道了🚬", "等等就去買電池"]
}

extension NotebookViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddNotebookTableViewCell.identifer, for: indexPath)
            guard let addNotebookCell = cell as? AddNotebookTableViewCell else { return cell }
            return addNotebookCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NotebookTableViewCell.identifer, for: indexPath)
            guard let notebookCell = cell as? NotebookTableViewCell else { return cell }
            notebookCell.userNameLabel.text = data[indexPath.row]
            notebookCell.contentLabel.text = data2[indexPath.row]
            notebookCell.timeLabel.text = "2019/7/2"
            return notebookCell
        }

    }
    
}

extension NotebookViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
    
}
