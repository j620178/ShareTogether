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

protocol AddExpenseItem: UITableViewDelegate, UITableViewDataSource {
    
}

class AddExpenseViewController: STBaseViewController {
    
    override var isHideNavigationBar: Bool {
        return true
    }
    
    let locationManager = CLLocationManager()
    
    let titleString = ["類型", "消費", "付款", "分帳", "日期"]
    
    var members = [MemberInfo]() {
        didSet {
            print(members)
            payerController.members = members
            splitController.members = members
            tableView.reloadData()
        }
    }
    
    var lastVelocityYSign = 0
    
    lazy var amountTypeController = AmountTypeController(tableView: tableView)
    
    lazy var expenseController = ExpenseController(tableView: tableView)
    
    lazy var payerController = PayerController(tableView: tableView)
    
    lazy var splitController = SplitController(tableView: tableView)
    
    lazy var payDateController = PayDateController(tableView: tableView)
    
    lazy var items: [AddExpenseItem] = [amountTypeController,
                                        expenseController,
                                        payerController,
                                        splitController,
                                        payDateController]
    
    let annotation = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
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

    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.setImage(.getIcon(code: "ios-checkmark", color: .white, size: 40), for: .normal)
            addButton.backgroundColor = .STTintColor
        }
    }
    
    @IBAction func clickCancelButton(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickAddButton(_ sender: UIButton) {
        
        guard let uid = AuthManager.shared.uid,
            let amountText = expenseController.expenseInfo[0],
            let amount = Double(amountText),
            let desc = expenseController.expenseInfo[1],
            let payerInfo = payerController.payInfo,
            let splitInfo = splitController.splitInfo,
            let date = payDateController.selectDate
        else { return }
        
        let expense = Expense(type: amountTypeController.amountTypeIndex,
                              desc: desc, userID: uid,
                              amount: amount,
                              payerInfo: payerInfo,
                              splitInfo: splitInfo,
                              location: annotation.coordinate,
                              time: date)

        FirestoreManager.shared.addExpense(expense: expense) { result in
            switch result {

            case .success:
                print("success")
            case .failure(let error):
                print(error)
            }
        }

        dismiss(animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBase()
        
        setupMap()
        
        fetchMember()

        let gestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        gestureUp.direction = .up
        self.containerView.addGestureRecognizer(gestureUp)
    
        expenseController.delegate = self
        payerController.delegate = self
        splitController.delegate = self
        
        payDateController.fetchDayOfWeek()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addButton.layer.cornerRadius = addButton.frame.height / 2
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus()
            == .notDetermined {
            // 取得定位服務授權
            locationManager.requestWhenInUseAuthorization()
            
            // 開始定位自身位置
            locationManager.startUpdatingLocation()
        }
            // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",
                message:
                "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(
                alertController,
                animated: true, completion: nil)
        }
            // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus()
            == .authorizedWhenInUse {
            // 開始定位自身位置
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 停止定位自身位置
        locationManager.stopUpdatingLocation()
    }
    
    func fetchMember() {
        FirestoreManager.shared.getMembers { [weak self] result in
            switch result {
                
            case .success(var members):
                var index = 0
                for member in members {
                    
                    if member.id == UserInfoManager.shaered.currentUserInfo?.id {
                        let temp = members.remove(at: index)
                        members.insert(temp, at: 0)
                        self?.members = members
                        break
                    }
                    
                    index += 1

                }

            case .failure:
                print("error")
            }
        }
        
    }
    
    func setupBase() {
        
        containerView.addCornerAndShadow(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    
    }
    
    func setupMap() {
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .follow
        
        annotation.title = "Test"

        
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
        return items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleString[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .STGray
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items[section].tableView(tableView, numberOfRowsInSection: section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return items[indexPath.section].tableView(tableView, cellForRowAt: indexPath)

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
        
        items[indexPath.section].tableView?(tableView, didSelectRowAt: indexPath)
        
    }
    
}

extension AddExpenseViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 印出目前所在位置座標
        let currentLocation = locations[0] as CLLocation
        
        annotation.coordinate = currentLocation.coordinate
        mapView.showAnnotations([annotation], animated: true)
    }
    
}

extension AddExpenseViewController: MKMapViewDelegate {
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        annotation.coordinate = mapView.centerCoordinate
    }
    
}

extension AddExpenseViewController: ExpenseTextFieldDelegate {
    
    func keyboardBeginEditing(controller: ExpenseController) {
        switchMapHeight(direction: .up)
    }

}

extension AddExpenseViewController: PayerControllerDelegate {
    
    func didSelectPayTypeAt(_ indexPath: IndexPath) {

        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for member in members {
            let action = UIAlertAction(title: member.name, style: .default) { [weak self] action in
                
                guard let strongSelf = self else { return }
                
                var payInfo = AmountInfo(type: 0, amountDesc: [AmountDesc]())
                
                for member in strongSelf.members {
                    
                    if member.name == action.title {
                        payInfo.amountDesc.append(AmountDesc(member: member, value: 1))

                    } else {
                        payInfo.amountDesc.append(AmountDesc(member: member, value: nil))
                    }
                    
                }
                
                strongSelf.payerController.payInfo = payInfo

            }
            controller.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }

}

extension AddExpenseViewController: SplitControllerDelegate {
    
    func didSelectSplitTypeAt(_ indexPath: IndexPath) {
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: CalculatorViewController.identifier),
            let calculatorVC = nextVC as? CalculatorViewController
        else { return }
        
        calculatorVC.splitInfo = splitController.splitInfo
        
        calculatorVC.passCalculateDateHandler = { [weak self] spliteInfo in
            self?.splitController.splitInfo = spliteInfo
        }
        
        show(calculatorVC, sender: nil)
    }
    
}
