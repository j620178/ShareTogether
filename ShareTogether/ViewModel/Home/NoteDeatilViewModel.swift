//
//  NoteDeatilViewModel.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/10.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class NoteDetailViewModel: NSObject {
    
    func uploadNoteComment(noteID: String,
                           content: String?,
                           mediaID: String?,
                           completion: ((Result<String, Error>) -> Void)?) {
                  
        guard let uid = CurrentManager.shared.user?.id else { return }
          
        let noteComment = NoteComment(id: nil, auctorID: uid, content: content, mediaID: mediaID, time: Date())
          
        FirestoreManager.shared.addNoteComment(noteID: noteID, noteComments: noteComment) { result in
            completion?(result)
        }
    }
     
    func getComments(noteID: String,
                     completion: @escaping (Result<[NoteComment], Error>) -> Void) {
         
        FirestoreManager.shared.getNoteComment(noteID: noteID) { result in
             
            completion(result)
        }
    }
    
}
