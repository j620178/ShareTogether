//
//  MainViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    enum InfoType: String {
        case expense = "交易紀錄"
        case statistics = "金額統計"
        case result = "結算結果"
        //case map = "交易地圖"
        case active = "活動紀錄"
    }
    
    let infoItems = [InfoType.expense, InfoType.statistics, InfoType.result, InfoType.active]
    
    lazy var expenseListViewModel: ExpenseRecodeViewModel = {
        return ExpenseRecodeViewModel()
    }()
    
    lazy var statisticsViewModel: StatisticsViewModel = {
        return StatisticsViewModel()
    }()
    
    lazy var resultViewModel: ResultViewModel = {
        return ResultViewModel()
    }()
    
    lazy var activeViewModel: ActiveViewModel = {
        return ActiveViewModel()
    }()

    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var infoTypeSelectionView: ScrollSelectionView! {
        didSet {
            infoTypeSelectionView.dataSource = self
            infoTypeSelectionView.delegate = self
        }
    }
    
    @IBOutlet weak var infoContainer: UIScrollView! {
        didSet {
            infoContainer.delegate = self
        }
    }

    @IBAction func clickTapView(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            print(1)
        case 2:
            print(2)
        case 3:
            print(3)
        default:
            break
        }
        
    }

    let stackView = UIStackView()
    
    let expenseTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerWithNib(indentifer: ExpenseTableViewCell.identifer, bundle: nil)
        return tableView
    }()
    
    lazy var resultTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerWithNib(indentifer: ResultTableViewCell.identifer, bundle: nil)
        return tableView
    }()
    
    lazy var statisticsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerWithNib(indentifer: StatisticsTableViewCell.identifer, bundle: nil)
        return tableView
    }()
    
    lazy var activeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerWithNib(indentifer: ActiveTableViewCell.identifer, bundle: nil)
        return tableView
    }()
    
    let tabView = STTabView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        bannerView.layer.cornerRadius = 30.0
        bannerView.layer.maskedCorners = [CACornerMask.layerMaxXMaxYCorner, CACornerMask.layerMinXMaxYCorner]
        setupInfoContainerView()
        
        view.addSubview(tabView)
        tabView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            tabView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabView.topAnchor.constraint(equalTo: tabView.stackView.topAnchor)
        ])

        preparePage(currnetIndex: infoTypeSelectionView.selectIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: { [weak self] in
            self?.tabView.constraint?.isActive = false
            self?.tabView.constraint?.constant = 0
            self?.tabView.constraint?.isActive = true
            self?.view.layoutIfNeeded()
        }, completion: nil)

    }
    
    func setupInfoContainerView() {
        
        infoContainer.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: infoContainer.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: infoContainer.heightAnchor)
        ])
        
    }
    
    func preparePage(currnetIndex: Int) {
        
        if currnetIndex == 0 {
            stackView.addArrangedSubview(expenseTableView)
            expenseTableView.widthAnchor.constraint(equalTo: infoContainer.widthAnchor).isActive = true
            expenseTableView.dataSource = expenseListViewModel
            expenseTableView.delegate = expenseListViewModel
            expenseTableView.separatorStyle = .none
            expenseTableView.backgroundColor = .clear
        }
        
        let targetIndex = currnetIndex + 1
        
        guard infoItems.count > targetIndex else { return }
        
        switch infoItems[targetIndex] {

        case .expense:  break
        case .statistics:
            stackView.addArrangedSubview(statisticsTableView)
            statisticsTableView.widthAnchor.constraint(equalTo: infoContainer.widthAnchor).isActive = true
            statisticsTableView.dataSource = statisticsViewModel
            statisticsTableView.delegate = statisticsViewModel
            statisticsTableView.separatorStyle = .none
            statisticsTableView.backgroundColor = .clear
        case .result:
            stackView.addArrangedSubview(resultTableView)
            resultTableView.widthAnchor.constraint(equalTo: infoContainer.widthAnchor).isActive = true
            resultTableView.dataSource = resultViewModel
            resultTableView.delegate = resultViewModel
            resultTableView.separatorStyle = .none
            resultTableView.backgroundColor = .clear
//        case .map:
//            stackView.addArrangedSubview(expenseMapView)
//            expenseMapView.widthAnchor.constraint(equalTo: infoContainer.widthAnchor).isActive = true
//            let latDelta = 0.25
//            let longDelta = 0.25
//            let currentLocationSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
//
//            let center = CLLocation(latitude: 25.047342, longitude: 121.549285)
//            let currentRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
//            expenseMapView.setRegion(currentRegion, animated: true)
        case .active:
            stackView.addArrangedSubview(activeTableView)
            activeTableView.widthAnchor.constraint(equalTo: infoContainer.widthAnchor).isActive = true
            activeTableView.dataSource = activeViewModel
            activeTableView.delegate = activeViewModel
            activeTableView.separatorStyle = .none
            activeTableView.backgroundColor = .clear
        }
        
    }
    
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == infoContainer {
            let screenPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            
            if screenPage > infoTypeSelectionView.selectIndex {
                infoTypeSelectionView.switchIndicatorAt(index: screenPage)
                preparePage(currnetIndex: screenPage)
            } else if screenPage < infoTypeSelectionView.selectIndex {
                infoTypeSelectionView.switchIndicatorAt(index: screenPage)
            }
        }
        
    }
}

extension MainViewController: ScrollSelectionViewDataSource {
    func numberOfItems(scrollSelectionView: ScrollSelectionView) -> Int {
        return infoItems.count
    }
    
    func titleForItem(scrollSelectionView: ScrollSelectionView, index: Int) -> String {
        return infoItems[index].rawValue
    }
    
}

extension MainViewController: ScrollSelectionViewDelegate {
    func scrollSelectionView(scrollSelectionView: ScrollSelectionView, didSelectIndexAt index: Int) {
        let index = infoTypeSelectionView.selectIndex
        infoContainer.setContentOffset(CGPoint(x: index * Int(UIScreen.main.bounds.width), y: 0), animated: true)
        if (index + 1) >= stackView.subviews.count {
            preparePage(currnetIndex: index)
        }
    }
}
