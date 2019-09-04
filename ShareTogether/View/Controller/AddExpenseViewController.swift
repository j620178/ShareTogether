//
//  AddExpenseViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/30.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import AVFoundation

class AddExpenseViewController: STBaseViewController {
    
    override var isHideNavigationBar: Bool {
        return true
    }
    
    enum CategoryType: String {
        case usd = "logo-usd"
        case car = "ios-car"
        case subway = "ios-subway"
        case bicycle = "ios-bicycle"
        case gasStation = "local.gas.station"
        case parking = "local.parking"
        case bed = "ios-bed"
        case bus = "ios-bus"
        case gift = "ios-gift"
        case shirt = "ios-shirt"
        case restaurant = "ios-restaurant"
        case wine = "ios-wine"
    }
    
    var categoryData: [CategoryType] = [.usd, .car, .subway, .bicycle, .bed, .bus, .gift, .shirt, .restaurant, .wine]
    var selectedCategory = [true, false, false, false, false, false, false, false, false, false]
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var amountTextfield: UITextField!
    
    @IBOutlet weak var descTextfield: UITextField!
    
    @IBOutlet weak var splitButton: UIButton! {
        didSet {
            splitButton.setImage(.getIcon(code: "ios-pie", color: .whiteAlphaOf(0.75), size: 30), for: .normal)
        }
    }
    
    @IBOutlet weak var scannerButton: UIButton! {
        didSet {
            scannerButton.setImage(.getIcon(code: "ios-barcode", color: .whiteAlphaOf(0.75), size: 30), for: .normal)
        }
    }

    @IBOutlet weak var categoryCollectionView: UICollectionView! {
        didSet {
            categoryCollectionView.dataSource = self
            categoryCollectionView.delegate = self
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = CGSize(width: 60, height: 60)
            flowLayout.minimumInteritemSpacing = 5
            flowLayout.minimumLineSpacing = 5
            categoryCollectionView.collectionViewLayout = flowLayout
        }
    }
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setImage(.getIcon(code: "ios-close", color: .STBlack, size: 40), for: .normal)
            cancelButton.backgroundColor = .white
        }
    }

    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setImage(.getIcon(code: "ios-arrow-round-forward", color: .STBlack, size: 40), for: .normal)
            nextButton.backgroundColor = .white
        }
    }
    
    @IBAction func clickCancelButton(_ sender: UIButton) {
        if amountTextfield.isFirstResponder {
            amountTextfield.resignFirstResponder()
        } else {
            descTextfield.resignFirstResponder()
        }

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickScannerButton(_ sender: UIButton) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBase()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
    }
    
    deinit {
        print("AE deinit")
    }
    
    func setupBase() {
        amountTextfield.layer.cornerRadius = 10.0
        amountTextfield.clipsToBounds = true
        amountTextfield.becomeFirstResponder()
        amountTextfield.leftViewMode = .always
        amountTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        descTextfield.layer.cornerRadius = 10.0
        descTextfield.clipsToBounds = true
        descTextfield.leftViewMode = .always
        descTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        containerView.backgroundColor = .STBlue
        containerView.layer.cornerRadius = 20.0
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
    }
}

extension AddExpenseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifer,
            for: indexPath)
        
        guard let categoryCell = cell as? CategoryCollectionViewCell else { return cell }

        if selectedCategory[indexPath.row] {
            categoryCell.setupImage(image:
                .getIcon(code: categoryData[indexPath.row].rawValue, color: .STBlack, width: 60, height: 60),
                color: .STBlack)
        } else {
            categoryCell.setupImage(image:
                .getIcon(code: categoryData[indexPath.row].rawValue, color: .white, width: 60, height: 60),
                color: .white)
        }
        
        return categoryCell
    }
    
}

extension AddExpenseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for index in selectedCategory.indices {
            selectedCategory[index] = false
            if index == indexPath.row {
                selectedCategory[index] = true
            }
        }
        collectionView.reloadData()
        
    }
}
