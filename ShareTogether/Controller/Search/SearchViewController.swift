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
    
    @IBOutlet weak var scrollSelectionView: ScrollSelectionView! {
        didSet {
            scrollSelectionView.dataSource = self
        }
    }
    
    var viewModel = SearchViewModel()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerWithNib(indentifer: ActivityTableViewCell.identifer)
        }
    }
    
    @IBOutlet weak var switchTypeButton: UIButton!
    
    var mapView: MKMapView?
    
    var annotations = [MKPointAnnotation]() {
        didSet {
            mapView?.showAnnotations(annotations, animated: true)
        }
    }
    
    @IBAction func switchType(_ sender: UIButton) {
        switchType()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        mapView = MKMapView(frame: view.frame)

        view.addSubview(mapView!)
        setupMap()
        //mapView?.isHidden = true
    
        view.bringSubviewToFront(goSearchButton)
        view.bringSubviewToFront(switchTypeButton)
        
        goSearchButton.layer.borderWidth = 1.0
        goSearchButton.layer.borderColor = UIColor.backgroundLightGray.cgColor
        goSearchButton.clipsToBounds = true
        goSearchButton.backgroundColor = .white
        goSearchButton.setImage(.getIcon(code: "ios-search", color: .darkGray, size: 20), for: .normal)
        
        viewModel.fectchData()
        viewModel.reloadMapHandler = { [weak self] annotations in
            self?.annotations = annotations
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        goSearchButton.layer.cornerRadius = goSearchButton.frame.height / 4
    }
    
    func setupMap() {
        
        mapView?.delegate = self
        mapView?.showsUserLocation = false
        mapView?.userTrackingMode = .none
        
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

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SearchViewController: CLLocationManagerDelegate {
    
}

extension SearchViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.title)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
    annotationView.clusteringIdentifier = "identifier"
    return annotationView
    }
}

extension SearchViewController: ScrollSelectionViewDataSource {
    
    func numberOfItems(scrollSelectionView: ScrollSelectionView) -> Int {
        return 10
    }
    
    func titleForItem(scrollSelectionView: ScrollSelectionView, index: Int) -> String {
        return "12345"
    }
    
    func colorOfTitleForItem(scrollSelectionView: ScrollSelectionView) -> UIColor {
        return .STTintColor
    }
    
}
