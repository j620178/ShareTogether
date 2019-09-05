//
//  GroupViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/2.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import SwiftIconFont

class GroupViewController: STBaseViewController {
    
    override var isHideNavigationBar: Bool {
        return true
    }
    
    @IBOutlet weak var collection: UICollectionView! {
        didSet {
            collection.dataSource = self
            collection.delegate = self
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 10 - 16 * 2) / 2, height: 140)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            collection.collectionViewLayout = flowLayout
        }
    }
    
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.setImage(.getIcon(code: "ios-close", color: .STGray, size: 40), for: .normal)
            backButton.backgroundColor = .backgroundLightGray
            backButton.layer.cornerRadius = 20
        }
    }
    
    @IBAction func clickBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension GroupViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewGroupCollectionViewCell.identifer, for: indexPath)
            
            guard let newGroupCell = cell as? NewGroupCollectionViewCell else { return cell }
            
            return newGroupCell
            
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GroupCollectionViewCell.identifer, for: indexPath)
            
            guard let groupCell = cell as? GroupCollectionViewCell else { return cell }
            
            groupCell.layer.cornerRadius = 10
            
            groupCell.selectedImageView.setIcon(code: "ios-checkmark", color: .white)
            
            groupCell.groupImage.image = UIImage(named: "aso")
            
            return groupCell
        }
    
    }
    
}

extension GroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let nextVC = UIStoryboard.group.instantiateViewController(withIdentifier: AddGroupViewController.identifier)
            show(nextVC, sender: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
