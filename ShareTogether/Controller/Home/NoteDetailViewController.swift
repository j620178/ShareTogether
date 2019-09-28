//
//  NoteDetailViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import GiphyUISDK
import GiphyCoreSDK

class NoteDetailViewController: STBaseViewController {
    
    override var isEnableIQKeyboard: Bool {
        return false
    }
    
    var note: Note?
    
    var noteComments = [NoteComment]() {
        didSet {
            tableView.reloadData()
            if !oldValue.isEmpty {
                let indexPath = IndexPath(row: noteComments.count - 1, section: 1)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    lazy var giphy: GiphyViewController = {
        let giphy = GiphyViewController()
        giphy.delegate = self
        giphy.layout = .carousel
        return giphy
    }()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    @IBOutlet weak var giphyButton: UIButton! {
        didSet {
            giphyButton.setImage(.getIcon(code: "ios-happy", color: .STDarkGray, size: 25), for: .normal)
        }
    }
    
    @IBOutlet weak var postButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
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
        
        postButtonWidthConstraint.constant = 0
        
        GiphyUISDK.configure(apiKey: "XSl7ujy13Z2ukhWYipP96Y9PJ5YCWAQS")
        
        getComment()
        
    }
    
    @IBAction func clickPostButton(_ sender: UIButton) {
        
        uploadNoteComment(content: textField.text, mediaID: nil)
        
    }
    
    @IBAction func clickGiphyButton(_ sender: UIButton) {
        
        present(giphy, animated: true, completion: nil)
        
    }

    @objc func keyboardWillChangeFrame(_ notification: Notification) {

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            textFieldBottomConstraint.constant = keyboardRectangle.height - (self.view.safeAreaInsets.bottom > 0 ? 34 : 0)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldBottomConstraint.constant = 0
    }
    
    func uploadNoteComment(content: String?, mediaID: String?) {
        
        LKProgressHUD.showLoading(view: self.view)
        
        guard let uid = CurrentInfoManager.shared.user?.id,
             let note = note else { return }
         
        let noteComment = NoteComment(id: nil, auctorID: uid, content: content, mediaID: mediaID, time: Date())
         
        FirestoreManager.shared.addNoteComment(noteID: note.id, noteComments: noteComment) { [weak self] result in
            switch result {
                 
            case .success:
                
            self?.textField.resignFirstResponder()
            self?.textField.text = nil
            LKProgressHUD.showSuccess(text: "發布成功", view: self?.view)
                
            case .failure:
            LKProgressHUD.showFailure(view: self?.view)
            }
        }
    }
    
    func getComment() {
        
        guard let note = note else { return }
        
        FirestoreManager.shared.getNoteComment(noteID: note.id) { [weak self] result in
            switch result {
                
            case .success(let noteComments):
                self?.noteComments = noteComments
            case .failure:
                LKProgressHUD.showFailure()
            }
        }
    }
    
}

extension NoteDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : noteComments.count
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
            
            if noteComments[indexPath.row].mediaID == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoteCommentTableViewCell.identifer, for: indexPath)
                
                guard let noteInfoCell = cell as? NoteCommentTableViewCell,
                    let content = noteComments[indexPath.row].content,
                    let user = CurrentInfoManager.shared.getMemberInfo(uid: noteComments[indexPath.row].auctorID) else {
                    return cell
                }
                
                noteInfoCell.viewModel = NoteCommentCellViewModel(userImageURL: user.photoURL,
                                                                  userName: user.name,
                                                                  content: content,
                                                                  time: noteComments[indexPath.row].time.toFullTimeFormat)
                
                return noteInfoCell
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: NoteGiphyTableViewCell.identifer, for: indexPath)
                
                guard let noteGiphyCell = cell as? NoteGiphyTableViewCell,
                    let mediaID = noteComments[indexPath.row].mediaID,
                    let user = CurrentInfoManager.shared.getMemberInfo(uid: noteComments[indexPath.row].auctorID) else {
                    return cell
                }
                
                noteGiphyCell.viewModel = NoteGiphyCellViewModel(userImageURL: user.photoURL,
                                                                  userName: user.name,
                                                                  mediaID: mediaID,
                                                                  time: noteComments[indexPath.row].time.toFullTimeFormat)
                
                return noteGiphyCell
                
            }
        
        }

    }
    
}

extension NoteDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let user = CurrentInfoManager.shared.user else { return }
        
    }
}

extension NoteDetailViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if range.lowerBound != 0 || string != "" {
            postButtonWidthConstraint.constant = 45
        } else {
            postButtonWidthConstraint.constant = 0
        }
        
        return true
    }
    
}

extension NoteDetailViewController: GiphyDelegate {
    
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        print(media.id)
        
        uploadNoteComment(content: nil, mediaID: media.id)
        
        giphyViewController.dismiss(animated: true, completion: nil)
        textField.resignFirstResponder()
    }
    
    func didDismiss(controller: GiphyViewController?) {
        controller?.dismiss(animated: true, completion: nil)
    }
    
}
