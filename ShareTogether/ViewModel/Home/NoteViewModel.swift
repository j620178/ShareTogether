//
//  ActiveViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class NoteViewModel: NSObject {
    
    private var notes = [Note]()
    
    var notebookCellViewModel = [NotebookCellViewModel]() {
        didSet {
            reloadTableViewHandler?()
        }
    }
    
    var reloadTableViewHandler: (() -> Void)?
    
    func fetchData() {
        
        FirestoreManager.shared.getNotes { [weak self] result in
            
            switch result {
                
            case .success(let notes):
                
                self?.notes = notes
                
                self?.processData()
                
            case .failure(let error):
                
                LKProgressHUD.showFailure(text: error.localizedDescription)
            }
        }
    }
    
    private func processData() {
        
        var notebookCellViewModel = [NotebookCellViewModel]()
        
        for note in notes {
            
            let user = CurrentManager.shared.getMemberInfo(uid: note.auctorID)
            
            let viewModel = NotebookCellViewModel(userImageURL: user?.photoURL,
                                                  userName: user?.name ?? "",
                                                  content: note.content,
                                                  commentCount: note.comments?.count ?? 0,
                                                  time: note.time.toNowFormat)
            
            notebookCellViewModel.append(viewModel)
            
        }
        
        self.notebookCellViewModel = notebookCellViewModel
    }
    
    func getViewModel(indexPath: IndexPath) -> NotebookCellViewModel {
        
        return notebookCellViewModel[indexPath.row]
    }
    
    func getNote(index: Int) -> Note {
        
        return notes[index]
    }
    
    func getNoteCount() -> Int {
        
        return notes.count
    }
}
