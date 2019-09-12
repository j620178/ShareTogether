//
//  AddExpenseViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/30.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class AddExpenseViewController: STBaseViewController {
    
    enum AddExpenseTableContent {
        case type
        case expense
        case payer
        case split
    }
    
    override var isHideNavigationBar: Bool {
        return true
    }
    
    let locationManager = CLLocationManager()
    
    let titleString = ["類型", "消費", "付款", "對象", "日期"]
    
    let textfieldPlaceHolder = ["請輸入消費金額", "請輸入消費說明"]
    
    var isSplit = [true, true, true, true, true]
    
    var lastVelocityYSign = 0
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerWithNib(indentifer: SelectionTableViewCell.identifer)
            tableView.registerWithNib(indentifer: TextFieldTableViewCell.identifer)
            tableView.registerWithNib(indentifer: CheckBoxTableViewCell.identifer)
            tableView.registerWithNib(indentifer: SplitTableViewCell.identifer)
            tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: ExpenseTableViewCell.identifer)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setImage(.getIcon(code: "ios-close", color: .STRed, size: 40), for: .normal)
            cancelButton.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        }
    }

    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setImage(.getIcon(code: "ios-checkmark", color: .white, size: 40), for: .normal)
            nextButton.backgroundColor = .STTintColor
        }
    }
    
    @IBAction func clickCancelButton(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickAddButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBase()
        
        setupMap()

        let gestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        gestureUp.direction = .up
        self.containerView.addGestureRecognizer(gestureUp)

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
        
        containerView.addCornerAndShadow(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    
    }
    
    func setupMap() {
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
//        let latDelta = 0.25
//        let longDelta = 0.25
//        let currentLocationSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
//
//        let center = CLLocation(latitude: 25.047342, longitude: 121.549285)
//        let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
//        mapView.setRegion(currentRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.title = "Test"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 25.047342, longitude: 121.549285)
        mapView.showAnnotations([annotation], animated: true)
    }
    
    func switchMapHeight(direction: Direction) {
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)),
            let textFieldCell = cell as? TextFieldTableViewCell else { return }
        
        if direction == .up {
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.mapHeightConstraint.constant = 36
                self?.view.layoutIfNeeded()
            }
            tableView.isScrollEnabled = true
        } else {
            
            if textFieldCell.textField.isFirstResponder {
                textFieldCell.textField.resignFirstResponder()
            }
            
            tableView.isScrollEnabled = false
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.mapHeightConstraint.constant = UIScreen.main.bounds.height / 2
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
 
        if sender.direction == .up {
            switchMapHeight(direction: .up)
        }
    
    }
    
}

extension AddExpenseViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleString.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleString[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .STGray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return isSplit.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.identifer, for: indexPath)
            
            guard let selectionCell = cell as? SelectionTableViewCell else { return cell }
            
            selectionCell.type = .image
            
            selectionCell.collectionView.reloadData()
            
            return selectionCell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifer, for: indexPath)
            
            guard let textfieldCell = cell as? TextFieldTableViewCell else { return cell }
            
            textfieldCell.delegate = self
    
            textfieldCell.textField.placeholder = textfieldPlaceHolder[indexPath.row]
            
            if indexPath.row == 0 {
                textfieldCell.textField.keyboardType = .numberPad
                textfieldCell.textField.becomeFirstResponder()
            }
            
            return textfieldCell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SplitTableViewCell.identifer, for: indexPath)
            
            guard let splitCell = cell as? SplitTableViewCell else { return cell }
            
            splitCell.updateLabelText(title: "littlema", type: "均分")
            
            return splitCell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxTableViewCell.identifer, for: indexPath)
            
            guard let checkBoxCell = cell as? CheckBoxTableViewCell else { return cell }
            
            checkBoxCell.updateCheckBoxImage(isSelectd: isSplit[indexPath.row])
            
            return checkBoxCell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.identifer, for: indexPath)
            
            guard let selectionCell = cell as? SelectionTableViewCell else { return cell }
            
            selectionCell.type = .text
            
            selectionCell.collectionView.reloadData()
            
            return selectionCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifer, for: indexPath)
            
            guard let textfieldCell = cell as? TextFieldTableViewCell else { return cell }
            
            return textfieldCell
        }

    }

}

extension AddExpenseViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= -75 {
            switchMapHeight(direction: .down)
        }
        
        let currentVelocityY =  scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        let currentVelocityYSign = Int(currentVelocityY).signum()
        
        if currentVelocityYSign != lastVelocityYSign,
            currentVelocityYSign != 0 {
            lastVelocityYSign = currentVelocityYSign
        }
        
        if lastVelocityYSign < 0 {
            switchMapHeight(direction: .up)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
            guard let nextVC = storyboard?.instantiateViewController(withIdentifier: SplitViewController.identifier)
            else { return }
            
            show(nextVC, sender: nil)
            
        } else if indexPath.section == 3 {
            guard let cell = tableView.cellForRow(at: indexPath),
                let checkBoxCell = cell as? CheckBoxTableViewCell else { return }
            
            isSplit[indexPath.row] = !isSplit[indexPath.row]
            
            checkBoxCell.updateCheckBoxImage(isSelectd: isSplit[indexPath.row])
        }
        
    }
    
}

extension AddExpenseViewController: CLLocationManagerDelegate {
    
}

extension AddExpenseViewController: MKMapViewDelegate {
    
}

extension AddExpenseViewController: TextFieldTableViewCellDelegate {
    func keyboardBeginEditing(tableViewCell: TextFieldTableViewCell) {
        switchMapHeight(direction: .up)
    }
}
