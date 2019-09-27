//
//  NoteDetailViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class NoteDetailViewController: STBaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func clickPostButton(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension NoteDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteDetailTableViewCell", for: indexPath)
            
            guard let noteInfoCell = cell as? NoteDetailTableViewCell else {
                return cell
            }
            return noteInfoCell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCommentTableViewCell", for: indexPath)
            
            guard let noteInfoCell = cell as? NoteDetailTableViewCell else {
                return cell
            }
            return noteInfoCell

        }

    }
    
}

extension NoteDetailViewController: UITableViewDelegate {
    
}
