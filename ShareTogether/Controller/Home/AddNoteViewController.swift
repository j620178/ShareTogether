//
//  AddNoteViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/26.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class AddNoteViewController: STBaseViewController {
    
    var user: UserInfo?
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.delegate = self
            textView.text = "請輸入欲記錄內容"
            textView.textColor = .lightGray
        }
    }
    
    @IBAction func clickPublishButton(_ sender: UIBarButtonItem) {
        
        guard let user = user else { return }
        
        let note = Notebook(id: nil, content: textView.text, auctorID: user.id, time: Date())
        
        FirestoreManager.shared.addNotebook(note: note) { result in
            switch result {
                
            case .success:
                self.dismiss(animated: true) {
                    LKProgressHUD.showSuccess()
                }
            case .failure:
                LKProgressHUD.showFailure()
            }
        }
        
    }
    
    @IBAction func clickCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textView.becomeFirstResponder()
        
        user = CurrentInfoManager.shared.user
        
        userImageView.setUrlImage(user!.photoURL)
        
        userNameLabel.text = user?.name

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }

}

extension AddNoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .STDarkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "請輸入欲記錄內容"
            textView.textColor = .lightGray
        }
    }
    
}