//
//  ExpenseMapViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import MapKit

class ExpenseMapViewController: STBaseViewController {
    
    override var isHideNavigationBar: Bool {
        return true
    }
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.setImage(.getIcon(code: "ios-arrow-round-back", color: .STGray, size: 40), for: .normal)
            backButton.backgroundColor = .backgroundLightGray
        }
    }
    
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.setImage(.getIcon(code: "ios-checkmark", color: .white, size: 40), for: .normal)
            addButton.backgroundColor = .STBlue
        }
    }
    
    @IBOutlet weak var mapViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func clickBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        setupContentView()
        //setupTabView()
        
        let annotation = MKPointAnnotation()
        annotation.title = "Test"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 25.047342, longitude: 121.549285)
        mapView.showAnnotations([annotation], animated: true)
        
        let gestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeView(_:)))
        gestureUp.direction = .up
        
        let gestureDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeView(_:)))
        gestureDown.direction = .down
    
        contentView.addGestureRecognizer(gestureUp)
        contentView.addGestureRecognizer(gestureDown)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        backButton.layer.cornerRadius = backButton.frame.height / 2
        addButton.layer.cornerRadius = addButton.frame.height / 2
    }
    
    func setupMap() {
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        let latDelta = 0.25
        let longDelta = 0.25
        let currentLocationSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        let center = CLLocation(latitude: 25.047342, longitude: 121.549285)
        let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        mapView.setRegion(currentRegion, animated: true)
    }
    
    func setupContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20.0
        contentView.layer.maskedCorners = [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner]
        
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
    }
    
    @objc func swipeView(_ sender: UISwipeGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            if sender.direction == .up {
                self?.mapViewHeightConstraint.constant = -1 * UIScreen.main.bounds.height / 3
            } else if sender.direction == .down {
                self?.mapViewHeightConstraint.constant = 0
            }
            self?.view.layoutIfNeeded()
        }

    }
    
//    func setupTabView() {
//
//        tabView.dataSource = self
//        tabView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(tabView)
//
//        NSLayoutConstraint.activate([
//            tabView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tabView.topAnchor.constraint(equalTo: tabView.stackView.topAnchor)
//        ])
//    }

}

extension ExpenseMapViewController: CLLocationManagerDelegate {
    
}

extension ExpenseMapViewController: MKMapViewDelegate {
    
}

//extension ExpenseMapViewController: TabViewDelegate {
//    func tabView(tabView: TabView, didSelectIndexAt index: Int) {
//
//    }
//}
//
//extension ExpenseMapViewController: TabViewDataSource {
//
//    func heightOfTabView(tabView: TabView) -> CGFloat {
//        return UIScreen.main.bounds.height / 2
//    }
//
//}
