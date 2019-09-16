//
//  GroupViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/2.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class GroupViewController: STBaseViewController {
    
    var viewModel = SelectionGroupViewModel()
    
    override var isHideNavigationBar: Bool {
        return true
    }
        
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
            newGroupButton.setImage(.getIcon(code: "ios-add", color: .white, size: 40), for: .normal)
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
    
    @IBAction func clickNewGroupButton(_ sender: UIButton) {
        let nextVC = UIStoryboard.group.instantiateViewController(withIdentifier: AddGroupViewController.identifier)
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func clickBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.reloadDataHandler = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.fetchDate()
    }

}

extension GroupViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupCollectionViewCell.identifer, for: indexPath)
        
        guard let groupCell = cell as? GroupCollectionViewCell else { return cell }
        
        groupCell.cellViewModel = viewModel.getCellViewModel(at: indexPath.row)
        
        return groupCell
    }
    
}

extension GroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userGroup = viewModel.getUserGroup(at: indexPath.row)
        UserInfoManager.shaered.setCurrentGroup(userGroup)

        dismiss(animated: true, completion: nil)
    }
}
