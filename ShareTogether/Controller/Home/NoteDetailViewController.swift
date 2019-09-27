//
//  NoteDetailViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class NoteDetailViewController: STBaseViewController {
    
    override var isEnableIQKeyboard: Bool {
        return false
    }
    
    var note: Note?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var textFieldContainerView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func clickPostButton(_ sender: UIButton) {
        
        guard let uid = CurrentInfoManager.shared.user?.id,
            let note = note else { return }
        
        let noteComment = NoteComment(id: nil, auctorID: uid, content: textField.text, gifURL: nil, time: Date())
        
        FirestoreManager.shared.addNoteComment(noteID: note.id, noteComments: noteComment) { [weak self] result in
            switch result {
                
            case .success(_):
                print("success")
                self?.textField.resignFirstResponder()
                self?.textField.text = nil
                if self?.note?.comments == nil { //|| self?.note?.comments!.isEmpty
                    self?.note?.comments = [noteComment]
                } else {
                    self?.note?.comments?.append(noteComment)
                }
                self?.tableView?.reloadData()
                let indexPath = IndexPath(row: self!.note!.comments!.count - 1, section: 1)
                self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                
            case .failure(_):
                print("failure")
            }
        }
        
    }
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    static var kBottomSafeHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height == 44 ? 34 : 0
       //return isFullScreen ? 34 : 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        textField.becomeFirstResponder()
        
        
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            print(keyboardRectangle.height)
            textFieldBottomConstraint.constant = keyboardRectangle.height - (self.view.safeAreaInsets.bottom > 0 ? 34 : 0)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldBottomConstraint.constant = 0
    }
    
}

extension NoteDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : note?.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteDetailTableViewCell.identifer, for: indexPath)
            
            guard let noteInfoCell = cell as? NoteDetailTableViewCell,
                let note = note,
                let user = CurrentInfoManager.shared.getMemberInfo(uid: note.auctorID) else {
                return cell
            }
            
            noteInfoCell.viewModel = NoteDetaiCellViewModel(userImageURL: user.photoURL,
                                                            userName: user.name,
                                                            content: note.content,
                                                            time: note.time.toFullTimeFormat)
            
            return noteInfoCell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteCommentTableViewCell.identifer, for: indexPath)
            
            guard let noteInfoCell = cell as? NoteCommentTableViewCell,
                let note = note,
                let comments = note.comments,
                let content = comments[indexPath.row].content,
                let user = CurrentInfoManager.shared.getMemberInfo(uid: comments[indexPath.row].auctorID) else {
                return cell
            }
            
            noteInfoCell.viewModel = NoteCommentCellViewModel(userImageURL: user.photoURL,
                                                              userName: user.name,
                                                              content: content,
                                                              time: comments[indexPath.row].time.toFullTimeFormat)
            
            return noteInfoCell

        }

    }
    
}

extension NoteDetailViewController: UITableViewDelegate {
    
}
