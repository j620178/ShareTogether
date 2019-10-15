//
//  GroupListViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/2.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol GroupListVCCoordinatorDelegate: AnyObject {
    
    func showGroupViewControllerFrom(_ viewController: STBaseViewController)
    
    func dismissGroupListViewControllerFrom(_ viewController: STBaseViewController)
}

class GroupListViewController: STBaseViewController {
    
    override var isHideNavigationBar: Bool { return true }
    
    weak var coordinator: GroupListVCCoordinatorDelegate?
    
    var viewModel: GroupListViewModel?
            
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 10 - 16 * 2) / 2, height: 140)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            collectionView.collectionViewLayout = flowLayout
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    @IBOutlet weak var newGroupButton: UIButton! {
        didSet {
            newGroupButton.setImage(.getIcon(code: "ios-arrow-round-forward", color: .white, size: 40), for: .normal)
            newGroupButton.backgroundColor = .STTintColor
            newGroupButton.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.setImage(.getIcon(code: "ios-close", color: .STGray, size: 40), for: .normal)
            backButton.backgroundColor = .backgroundLightGray
            backButton.layer.cornerRadius = 10
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.reloadDataHandler = { [weak self] in
            
            self?.collectionView.reloadData()
        }
        
        viewModel?.fetchDate()
    }
    
    @IBAction func clickAddGroupButton(_ sender: UIButton) {
        
        coordinator?.showGroupViewControllerFrom(self)
    }
    
    @IBAction func clickBackButton(_ sender: UIButton) {
        
        coordinator?.dismissGroupListViewControllerFrom(self)
    }
}

extension GroupListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.numberOfCells ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupCollectionViewCell.identifier, for: indexPath)
        
        guard let groupCell = cell as? GroupCollectionViewCell else { return cell }
        
        groupCell.cellViewModel = viewModel?.getCellViewModel(at: indexPath.row)
        
        return groupCell
    }
}

extension GroupListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewModel?.setCurrentGroup(index: indexPath.row)
        
        coordinator?.dismissGroupListViewControllerFrom(self)
    }
}
