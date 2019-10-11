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

private struct PrivateConstant {
    static let privateInfo = "PrivateInfo"
    static let plist = "plist"
    static let giphyKey = "GiphyKey"
}

protocol NoteDetailVCCoordinatorDelegate: AnyObject {
    
    func showGiphyViewControllerFrom(_ viewController: STBaseViewController)
    
    func showDeleteAlertControllerFrom(_ viewController: STBaseViewController,
                                       noteID: String,
                                       noteCommentID: String)
    
    func dismissGiphyViewControllerFrom(_ viewController: STBaseViewController)
}

class NoteDetailViewController: STBaseViewController {
    
    override var isEnableIQKeyboard: Bool { return false }
    
    weak var coordinator: NoteDetailVCCoordinatorDelegate?
    
    var viewModel: NoteDetailViewModel?
    
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
            giphyButton.setImage(.getIcon(code: "md-happy", color: .STDarkGray, size: 25), for: .normal)
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
        
        guard let path = Bundle.main.path(forResource: PrivateConstant.privateInfo, ofType: PrivateConstant.plist),
            let dict = NSDictionary(contentsOfFile: path),
            let body = dict as? [String: String],
            let key = body[PrivateConstant.giphyKey]
        else { return }
        
        GiphyUISDK.configure(apiKey: key)
        
        initComments()
        
        title = "貼文"
    }
    
    func initComments() {
        
        guard let note = note else { return }
         
        viewModel?.getComments(noteID: note.id, completion: { [weak self] result in
            switch result {

            case .success(let noteComments):

                self?.noteComments = noteComments

            case .failure:

                LKProgressHUD.showFailure()
            }
         })
    }
    
    @IBAction func clickPostButton(_ sender: UIButton) {
        
        guard let note = note else { return }
                
        viewModel?.uploadNoteComment(noteID: note.id,
                                     content: textField.text,
                                     mediaID: nil,
                                     completion: nil)
        textField.text = nil
    }
    
    @IBAction func clickGiphyButton(_ sender: UIButton) {
        
        coordinator?.showGiphyViewControllerFrom(self)
    }

    @objc func keyboardWillChangeFrame(_ notification: Notification) {

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            let bottomValue = CGFloat(self.view.safeAreaInsets.bottom > 0 ? 34 : 0)
            
            textFieldBottomConstraint.constant = keyboardRectangle.height - bottomValue
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
        
        return section == 0 ? 1 : noteComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteDetailTableViewCell.identifier, for: indexPath)
            
            guard let noteInfoCell = cell as? NoteDetailTableViewCell,
                let note = note,
                let user = CurrentManager.shared.getMemberInfo(uid: note.auctorID) else {
                return cell
            }
            
            noteInfoCell.viewModel = NoteDetailCellViewModel(userImageURL: user.photoURL,
                                                            userName: user.name,
                                                            content: note.content,
                                                            time: note.time.toNowFormat)
            
            return noteInfoCell
            
        } else {
            
            if noteComments[indexPath.row].mediaID == nil {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: NoteCommentTableViewCell.identifier,
                                                         for: indexPath)
                
                guard let noteInfoCell = cell as? NoteCommentTableViewCell,
                    let content = noteComments[indexPath.row].content,
                    let user = CurrentManager.shared.getMemberInfo(uid: noteComments[indexPath.row].auctorID) else {
                    return cell
                }
                
                noteInfoCell.viewModel = NoteCommentCellViewModel(userImageURL: user.photoURL,
                                                                  userName: user.name,
                                                                  content: content,
                                                                  time: noteComments[indexPath.row].time.toNowFormat)
                
                return noteInfoCell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: NoteGiphyTableViewCell.identifier,
                                                         for: indexPath)
                
                guard let noteGiphyCell = cell as? NoteGiphyTableViewCell,
                    let mediaID = noteComments[indexPath.row].mediaID,
                    let user = CurrentManager.shared.getMemberInfo(uid: noteComments[indexPath.row].auctorID) else {
                    return cell
                }
                
                noteGiphyCell.viewModel = NoteGiphyCellViewModel(userImageURL: user.photoURL,
                                                                 userName: user.name,
                                                                 mediaID: mediaID,
                                                                 time: noteComments[indexPath.row].time.toNowFormat)
                
                return noteGiphyCell
            }
        }
    }
}

extension NoteDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let user = CurrentManager.shared.user,
            let note = note else { return }
        
        if user.id == noteComments[indexPath.row].auctorID {
            
            coordinator?.showDeleteAlertControllerFrom(self,
                                                       noteID: note.id,
                                                       noteCommentID: self.noteComments[indexPath.row].id)
        }
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
        
        guard let note = note else { return }
                
        viewModel?.uploadNoteComment(noteID: note.id,
                                     content: nil,
                                     mediaID: media.id,
                                     completion: { [weak self] result in
                                        
                                        switch result {
                                            
                                        case .success: break
                                                                                        
                                        case .failure:
                                            
                                            LKProgressHUD.showFailure(view: self?.view)
                                            
                                        }
        })
        
        coordinator?.dismissGiphyViewControllerFrom(self)
    }
    
    func didDismiss(controller: GiphyViewController?) {
        
        coordinator?.dismissGiphyViewControllerFrom(self)
    }
}
