//
//  SearchViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/29.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: STBaseViewController {
    
    let data = ["增加一筆消費", "修改了紀錄", "增加一筆消費", "增加一筆消費", "增加一筆消費", "增加一筆消費", "增加一筆消費", "增加一筆消費"]
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var goSearchButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.registerWithNib(indentifer: ActivityTableViewCell.identifer)
        }
    }
    
    @IBOutlet weak var switchTypeButton: UIButton!
    
    var mapView: MKMapView?
    
    @IBAction func switchType(_ sender: UIButton) {
        switchType()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goSearchButton.addShadow()
        
        mapView = MKMapView(frame: view.frame)

        view.addSubview(mapView!)
        setupMap()
        mapView?.isHidden = true
    
        view.bringSubviewToFront(goSearchButton)
        view.bringSubviewToFront(switchTypeButton)
        
        goSearchButton.layer.borderWidth = 1.0
        goSearchButton.layer.borderColor = UIColor.backgroundLightGray.cgColor
        goSearchButton.clipsToBounds = true
        goSearchButton.backgroundColor = .white
        goSearchButton.setImage(.getIcon(code: "ios-search", color: .darkGray, size: 20), for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        goSearchButton.layer.cornerRadius = goSearchButton.frame.height / 4
    }
    
    func setupMap() {
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView?.delegate = self
        mapView?.showsUserLocation = true
        mapView?.userTrackingMode = .follow
        
        let annotation = MKPointAnnotation()
        annotation.title = "Test"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 25.047342, longitude: 121.549285)
        mapView?.showAnnotations([annotation], animated: true)
    }
    
    func switchType() {
        if mapView!.isHidden {
            mapView?.isHidden = false
            switchTypeButton.setTitle("列表", for: .normal)
        } else {
            mapView?.isHidden = true
            switchTypeButton.setTitle("地圖", for: .normal)
        }
    }

}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifer, for: indexPath)
        
        guard let activityCell = cell as? ActivityTableViewCell else { return cell }
        
        activityCell.contentLabel.text = data[indexPath.row]
        activityCell.timeLabel.text = "2019/09/02"
        
        return activityCell
    }
    
}

extension SearchViewController: CLLocationManagerDelegate {
    
}

extension SearchViewController: MKMapViewDelegate {
    
}
