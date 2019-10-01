//
//  NotebookTableViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class NoteViewController: STBaseViewController {
    
    let viewModel = NoteViewModel()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedSectionHeaderHeight = 50
            tableView.registerWithNib(indentifer: NotebookTableViewCell.identifer)
            tableView.registerWithNib(indentifer: AddNoteTableViewCell.identifer)
        }
    }
    
    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.reloadTableViewHandler = { [weak self] in
            self?.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(upadateCurrentGroup),
                                               name: NSNotification.Name(rawValue: "CurrentGroup"),
                                               object: nil)
        
        upadateCurrentGroup()
        
    }
    
    @objc func upadateCurrentGroup() {
        
        viewModel.fectchData()
    }

}

extension NoteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.notebookCellViewModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AddNoteTableViewCell.identifer, for: indexPath)
            
            guard let userPhotoURL = CurrentInfoManager.shared.user?.photoURL,
                let addNoteCell = cell as? AddNoteTableViewCell
            else { return cell }
    
            addNoteCell.userImageView.setUrlImage(userPhotoURL)
            
            return addNoteCell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: NotebookTableViewCell.identifer, for: indexPath)
            
            guard let notebookCell = cell as? NotebookTableViewCell,
                let user = CurrentInfoManager.shared.user else { return cell }
            
            notebookCell.cellViewModel = viewModel.getViewModel(indexPath: indexPath)
            
            let note = viewModel.getNote(index: indexPath.row)
            
            if user.id == note.auctorID {
                
                notebookCell.moreButton.alpha = 1
            
                notebookCell.clickMoreButtonHandler = { [weak self] in
                                        
                    let alertVC = UIAlertController.deleteAlert { _ in
                                        
                        FirestoreManager.shared.deleteNote(noteID: note.id)
                    }
                    
                    self?.present(alertVC, animated: true, completion: nil)
                    
                }
                
            } else {
                notebookCell.moreButton.alpha = 0
            }
            
            return notebookCell
            
        }
         
    }
    
}

extension NoteViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.tableViewDidScroll(viewController: self,
                                     offsetY: scrollView.contentOffset.y,
                                     contentSize: scrollView.contentSize)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let demoGroupID = Bundle.main.object(forInfoDictionaryKey: "DemoGroupID") as? String
            
            if demoGroupID == CurrentInfoManager.shared.group?.id {
                LKProgressHUD.showFailure(text: "範例群組無法新增資料，請建立新群組", view: self.view)
                return
            }
            
            let nextVC = UIStoryboard.home.instantiateViewController(identifier: "AddNoteNavigationController")
            
            present(nextVC, animated: true, completion: nil)
            
        } else {
            
            guard let nextVC = UIStoryboard.home.instantiateViewController(identifier: NoteDetailViewController.identifier)
                as? NoteDetailViewController else { return }
            
            nextVC.note = viewModel.getNote(index: indexPath.row)

            show(nextVC, sender: nil)
            
        }

    }
    
}
