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
    
    fileprivate var selectedCell: UICollectionViewCell?
    
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
    
    @IBOutlet weak var selectButton: UIButton! {
        didSet {
            selectButton.setImage(.getIcon(code: "ios-arrow-round-forward", color: .white, size: 40), for: .normal)
            selectButton.backgroundColor = .STTintColor
            selectButton.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.setImage(.getIcon(code: "ios-close", color: .STGray, size: 40), for: .normal)
            backButton.backgroundColor = .backgroundLightGray
            backButton.layer.cornerRadius = 10
        }
    }
    
    @IBAction func clickBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        userGroups[indexPath.row]
        
        groupCell.isSelectedImageView.setIcon(code: "ios-checkmark", color: .white)
        
        groupCell.groupNameLabel.text = groupData[indexPath.row]
        
        groupCell.groupImageView.image = UIImage(named: "aso")
        
        
        return groupCell
    }
    
}

extension GroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            self.selectedCell = self.collectionView.cellForItem(at: indexPath)
            
            let nextVC = UIStoryboard.group.instantiateViewController(withIdentifier: AddGroupViewController.identifier)
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension GroupViewController: Animatable {
    var containerView: UIView? {
        return self.collectionView
    }
    
    var childView: UIView? {
        return self.selectedCell
    }
}
