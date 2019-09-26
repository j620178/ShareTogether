//
//  NotebookTableViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    let viewModel = NoteViewModel()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedSectionHeaderHeight = 100
            tableView.register(AddNoteTableHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: AddNoteTableHeaderView.self))
            tableView.registerWithNib(indentifer: NotebookTableViewCell.identifer)
        }
    }
    
    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fectchData()
        
        viewModel.reloadTableViewHandler = { [weak self] in
            self?.tableView.reloadData()
        }
        
    }

}

// MARK: - Table view data source
extension NoteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.notebookCellViewModel.count == 0 ? (tableView.alpha = 0) : (tableView.alpha = 1)
        return viewModel.notebookCellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: AddNoteTableHeaderView.self))
        
        guard let noteHeaderView = headerView as? AddNoteTableHeaderView,
            let userPhotoURL = CurrentInfoManager.shared.user?.photoURL
        else { return headerView }
        
        noteHeaderView.userImageView.setUrlImage(userPhotoURL)
        
        noteHeaderView.clickHeaderViewHandler = { [weak self] in
            guard let nextVC = UIStoryboard.home.instantiateViewController(identifier: AddNoteViewController.identifier)
                as? AddNoteViewController else { return }
            
            self?.present(nextVC, animated: true, completion: nil)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotebookTableViewCell.identifer, for: indexPath)
        guard let notebookCell = cell as? NotebookTableViewCell else { return cell }
        notebookCell.cellViewModel = viewModel.getViewModel(indexPath: indexPath)
        return notebookCell

    }
    
}

// MARK: - Table view delegate
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
        delegate?.tableViewDidScroll(viewController: self, offsetY: scrollView.contentOffset.y)
    }
    
}
