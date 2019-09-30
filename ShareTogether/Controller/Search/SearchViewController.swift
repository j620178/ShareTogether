//
//  SearchViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import MapKit

class STAnnotation: MKPointAnnotation {
    var identifier: String!
}

class SearchViewController: STBaseViewController {
        
    let locationManager = CLLocationManager()
    
    var viewModel = SearchViewModel()
        
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView?.delegate = self
            mapView?.showsUserLocation = false
            mapView?.userTrackingMode = .none
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerWithNib(indentifer: ExpenseInfoTableViewCell.identifer, bundle: nil)
            tableView.registerWithNib(indentifer: ExepenseSplitTableViewCell.identifer, bundle: nil)
        }
    }
    
    @IBOutlet weak var infoWindow: UIView!
    
    @IBOutlet weak var infoWindowBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        setupViewModel()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(upadateCurrentGroup),
                                               name: NSNotification.Name(rawValue: "CurrentGroup"),
                                               object: nil)
    }
    
    func setupView() {
        
        textField.addSearchIconOnLeft()
        
        infoWindow.addCornerAndShadow(maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        infoWindowBottomConstraint.constant = -300
    }
    
    func setupViewModel() {
        
        viewModel.removeAnnotationHandler = { [weak self] in
            guard let strougSelf = self else { return }
            strougSelf.mapView?.removeAnnotations(strougSelf.viewModel.annotations)
        }

        viewModel.showAnnotationHandler = { [weak self] in
            guard let strougSelf = self else { return }
            strougSelf.mapView?.showAnnotations(strougSelf.viewModel.annotations, animated: true)
        }
        
        viewModel.updateLoadingHandler = { [weak self] in
            
            let isLoading = self?.viewModel.isLoading ?? false
            
            if isLoading {
                LKProgressHUD.showLoading()
            } else {
                LKProgressHUD.dismiss()
            }
            
        }
        
        viewModel.reloadInfoWindowHandler = { [weak self] text in
            self?.textField.text = text
            self?.tableView.reloadData()
        }
        
        viewModel.fectchData()
        
    }

    @objc func upadateCurrentGroup() {
        viewModel.fectchData()
    }
    
}

extension SearchViewController: CLLocationManagerDelegate {
    
}

extension SearchViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier:
            MKMapViewDefaultAnnotationViewReuseIdentifier,
            for: annotation)
        annotationView.clusteringIdentifier = "STClustering"
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? STMKPointAnnotation else { return }
        
        viewModel.userPressed(at: annotation.identifier)
        
        UIViewPropertyAnimator
            .runningPropertyAnimator(withDuration: 0.5,
                                     delay: 0,
                                     animations: { [weak self] in
                                        self?.infoWindowBottomConstraint.constant = 0
                                        self?.view.layoutIfNeeded()
                                     })
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        textField.text = nil
        
        UIViewPropertyAnimator
            .runningPropertyAnimator(withDuration: 0.5,
                                     delay: 0,
                                     animations: { [weak self] in
                                        self?.infoWindowBottomConstraint.constant = -300
                                        self?.view.layoutIfNeeded()
                                     })
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.selectedExpense?.splitInfo.amountDesc.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseInfoTableViewCell.identifer, for: indexPath)

            guard let expenseInfoCell = cell as? ExpenseInfoTableViewCell,
                let viewModel = viewModel.getSelectedExpenseViewModel() else { return cell }

            expenseInfoCell.viewModel = viewModel

            return expenseInfoCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExepenseSplitTableViewCell.identifer, for: indexPath)

            guard let exepenseSplitCell = cell as? ExepenseSplitTableViewCell,
                let viewModel = viewModel.getSelectedSplitViewModel(at: indexPath) else { return cell }

            exepenseSplitCell.viewModel = viewModel

            return exepenseSplitCell
        }
    }
}

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        guard let text = textField.text else { return false }
        
        viewModel.searchExpense(keyWord: text)
                
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        viewModel.resetExpenses()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        print(textField.text)
        if textField.text == nil {
            print("1")
        } else if textField.text == "" {
            print("2")
        }
        
    }
    
}
