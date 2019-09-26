//
//  ActiveViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

class NoteViewModel: NSObject {
    
    var notebooks = [Notebook]()
    
    var notebookCellViewModel = [NotebookCellViewModel]() {
        didSet {
            reloadTableViewHandler?()
        }
    }
    
    var reloadTableViewHandler: (() -> Void)?
    
    func fectchData() {
        
        FirestoreManager.shared.getNotebooks { [weak self] result in
            switch result {
                
            case .success(let notebooks):
                self?.notebooks = notebooks
                self?.processData()
            case .failure(let error):
                LKProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
        
    }
    
    func processData() {
        
        var notebookCellViewModel = [NotebookCellViewModel]()
        
        for notebook in notebooks {
            
            let user = CurrentInfoManager.shared.getMemberInfo(uid: notebook.auctorID)
            let viewModel = NotebookCellViewModel(userImageURL: user?.photoURL,
                                                  userName: user?.name ?? "",
                                                  content: notebook.content, time: notebook.time.toFullFormat())
            notebookCellViewModel.append(viewModel)
        }
        
        self.notebookCellViewModel = notebookCellViewModel
 
    }
    
    func getViewModel(indexPath: IndexPath) -> NotebookCellViewModel {
        return notebookCellViewModel[indexPath.row]
    }
    
}
