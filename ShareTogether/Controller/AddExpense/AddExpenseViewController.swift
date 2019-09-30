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
    
    let titleString = ["類型", "消費", "付款", "分帳", "日期"]
    
    let locationManager = CLLocationManager()
    
    var availableMembers: [MemberInfo] {
        return CurrentInfoManager.shared.availableMembers
    }
    
    var lastVelocityYSign = 0
    
    let annotation = MKPointAnnotation()
    
    var expense: Expense?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBase()
        
        expenseController.delegate = self
        payerController.delegate = self
        splitController.delegate = self
        
        if let expense = expense {
            amountTypeController.selectIndex = expense.type
            expenseController.expenseInfo[0] = "\(expense.amount)"
            expenseController.expenseInfo[1] = "\(expense.desc)"
            payerController.payInfo = expense.payerInfo
            splitController.splitInfo = expense.splitInfo
            payDateController.selectDate = expense.time.dateValue()
        }

        payDateController.initDayOfWeek()
                
        setupMap()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addButton.layer.cornerRadius = addButton.frame.height / 2
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if expense == nil {
            
            if CLLocationManager.authorizationStatus()
                == .notDetermined {

                locationManager.requestWhenInUseAuthorization()

                locationManager.startUpdatingLocation()

            } else if CLLocationManager.authorizationStatus()
                == .denied {

                let alertController = UIAlertController(
                    title: "定位權限已關閉",
                    message:
                    "如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(
                    title: "確認", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(
                    alertController,
                    animated: true, completion: nil)

            } else if CLLocationManager.authorizationStatus()
                == .authorizedWhenInUse {

                locationManager.startUpdatingLocation()
            }
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    func setupBase() {
        
        let gestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        gestureUp.direction = .up
        self.containerView.addGestureRecognizer(gestureUp)
        
        containerView.addCornerAndShadow(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        mapHeightConstraint.constant = UIScreen.main.bounds.height - 430
    
    }
    
    func setupMap() {
        
        mapView.delegate = self
        
        if let expense = expense {

            mapView.showsUserLocation = false
            mapView.userTrackingMode = .none

            let expensePos = CLLocationCoordinate2D(latitude: expense.position.latitude,
                                             longitude: expense.position.longitude)

            let region = MKCoordinateRegion(center: expensePos,
                                            latitudinalMeters: CLLocationDistance(exactly: 200)!,
                                            longitudinalMeters: CLLocationDistance(exactly: 200)!)

            mapView.setRegion(mapView.regionThatFits(region), animated: true)

        } else {

            locationManager.delegate = self
            locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
            locationManager.desiredAccuracy = kCLLocationAccuracyBest

            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
        
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
                self?.mapHeightConstraint.constant = UIScreen.main.bounds.height - 430
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
 
        if sender.direction == .up {
            switchMapHeight(direction: .up)
        }
    
    }
    
    @IBAction func clickCancelButton(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickAddButton(_ sender: UIButton) {
        
        let demoGroupID = Bundle.main.object(forInfoDictionaryKey: "DemoGroupID") as? String
        
        if demoGroupID == CurrentInfoManager.shared.group?.id {
            LKProgressHUD.showFailure(text: "範例群組無法新增資料，請建立新群組", view: self.view)
            return
        }
        
        guard let uid = CurrentInfoManager.shared.user?.id,
            let amount = Double(expenseController.expenseInfo[0]),
            expenseController.expenseInfo[1] != "",
            let payerInfo = payerController.payInfo,
            let splitInfo = splitController.splitInfo,
            let date = payDateController.selectDate
        else {
            LKProgressHUD.showFailure(text: "請輸入消費金額與說明", view: self.view)
            return
        }
        
        LKProgressHUD.show(view: self.view)
        var expense = Expense(type: amountTypeController.selectIndex,
                              desc: expenseController.expenseInfo[1],
                              userID: uid,
                              amount: amount,
                              payerInfo: payerInfo,
                              splitInfo: splitInfo,
                              location: annotation.coordinate,
                              time: date)
        
        if self.expense != nil {
            
            expense.id = self.expense!.id
            
            FirestoreManager.shared.upadteExpense(expense: expense) { [weak self] result in
                switch result {

                case .success:
                    
                    for member in CurrentInfoManager.shared.availableMembersWithoutSelf {
                        FirestoreManager.shared.addActivity(type: 1, targetMember: member, amount: expense.amount)
                    }
                    
                    LKProgressHUD.dismiss()
                    
                    self?.dismiss(animated: true, completion: nil)
                    
                    if let previousVC = self?.navigationController?.presentingViewController as? STNavigationController {
                        previousVC.popViewController(animated: true)
                    }
                    
                case .failure(let error):
                    LKProgressHUD.showFailure(text: error.localizedDescription)
                }
            }
            
        } else {
            
            FirestoreManager.shared.addExpense(expense: expense) { [weak self] result in
                switch result {

                case .success:
                    
                    for member in CurrentInfoManager.shared.availableMembersWithoutSelf {
                        FirestoreManager.shared.addActivity(type: 1, targetMember: member, amount: expense.amount)
                    }
                    LKProgressHUD.dismiss()
                    self?.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    LKProgressHUD.showFailure(text: error.localizedDescription)
                }
            }
            
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
        let currentLocation = locations[0] as CLLocation
        
        annotation.coordinate = currentLocation.coordinate
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
        
        for member in availableMembers {
            
            let action = UIAlertAction(title: member.name, style: .default) { [weak self] action in
                
                guard let strongSelf = self else { return }
                
                var payInfo = AmountInfo(type: 0, amountDesc: [AmountDesc]())
                
                for member in strongSelf.availableMembers {
                    
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
        
        if let amount = Double(expenseController.expenseInfo[0]) {
            guard let nextVC = storyboard?.instantiateViewController(withIdentifier: CalculatorViewController.identifier),
                let calculatorVC = nextVC as? CalculatorViewController
            else { return }
            
            calculatorVC.amount = amount
            
            calculatorVC.splitInfo = splitController.splitInfo
            
            calculatorVC.passCalculateDateHandler = { [weak self] spliteInfo in
                self?.splitController.splitInfo = spliteInfo
            }
            
            show(calculatorVC, sender: nil)
        } else {
            LKProgressHUD.showFailure(text: "分帳前請先填妥消費金額", view: self.view)
        }

    }
    
}
