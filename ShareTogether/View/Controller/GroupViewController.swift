//
//  GroupViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/2.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    @IBOutlet weak var collection: UICollectionView! {
        didSet {
            collection.dataSource = self
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 10 - 16 * 2) / 2, height: 140)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 10
            collection.collectionViewLayout = flowLayout
        }
    }
    
    let tabView = STTabView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(collection.frame)
    }
    
    func setupTabView() {
        view.addSubview(tabView)
        tabView.delegate = self
        tabView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabView.topAnchor.constraint(equalTo: tabView.stackView.topAnchor)
            ])
    }

}

extension GroupViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GroupCollectionViewCell.identifer, for: indexPath)
        
        guard let groupCell = cell as? GroupCollectionViewCell else { return cell }
        
        groupCell.layer.cornerRadius = 10
        
        groupCell.groupImage.image = UIImage(named: "aso")
        
        print(groupCell.frame)
        
        return groupCell
    }
    
}

extension GroupViewController: STTabViewDelegate {
    
}
