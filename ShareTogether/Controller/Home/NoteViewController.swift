//
//  NotebookTableViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol NoteVCCoordinatorDelegate: AnyObject {
    func addNoteFrom(_ viewController: STBaseViewController)
}

class NoteViewController: STBaseViewController {
    
    weak var coordinator: NoteVCCoordinatorDelegate?
    
    let viewModel = NoteViewModel()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedSectionHeaderHeight = 50
            tableView.registerWithNib(identifier: NotebookTableViewCell.identifier)
            tableView.registerWithNib(identifier: AddNoteTableViewCell.identifier)
        }
    }
    
    weak var delegate: HomeVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.reloadTableViewHandler = { [weak self] in
            self?.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCurrentGroup),
                                               name: NSNotification.Name(rawValue: "CurrentGroup"),
                                               object: nil)
        
        updateCurrentGroup()
        
    }
    
    @objc func updateCurrentGroup() {
        
        viewModel.fetchData()
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AddNoteTableViewCell.identifier, for: indexPath)
            
            guard let userPhotoURL = CurrentManager.shared.user?.photoURL,
                let addNoteCell = cell as? AddNoteTableViewCell
            else { return cell }
    
            addNoteCell.userImageView.setUrlImage(userPhotoURL)
            
            return addNoteCell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: NotebookTableViewCell.identifier, for: indexPath)
            
            guard let notebookCell = cell as? NotebookTableViewCell,
                let user = CurrentManager.shared.user else { return cell }
            
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
            
            guard !CurrentManager.shared.isDemoGroup() else {
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
