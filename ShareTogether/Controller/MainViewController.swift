//
//  MainViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var expenseRecodeViewModel: ExpenseRecodeViewModel = {
        return ExpenseRecodeViewModel()
    }()

    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var infoTypeSelectionView: ScrollSelectionView! {
        didSet {
            infoTypeSelectionView.dataSource = self
            infoTypeSelectionView.delegate = self
        }
    }
    @IBOutlet weak var infoContainer: UIScrollView!
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.registerWithNib(indentifer: ExpenseRecodeTableViewCell.identifer, bundle: nil)
        return tableView
    }()
    
    lazy var resultTableView: UITableView = {
        print("resultTableView")
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.registerWithNib(indentifer: ExpenseRecodeTableViewCell.identifer, bundle: nil)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        bannerView.layer.cornerRadius = 30.0
        bannerView.layer.maskedCorners = [CACornerMask.layerMaxXMaxYCorner , CACornerMask.layerMinXMaxYCorner]
        setupInfoContainerView()
    }
    
    func setupInfoContainerView() {
        
        let stackView = UIStackView()
        infoContainer.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: infoContainer.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: infoContainer.heightAnchor)
        ])
        
        for index in 0..<expenseRecodeViewModel.itemsString.count {
            var view = UIView()

            if index == 0 {
                view = tableView
                tableView.dataSource = self
                tableView.delegate = self
                tableView.separatorStyle = .none
                tableView.backgroundColor = UIColor.clear
            }
            
            stackView.addArrangedSubview(view)
            view.widthAnchor.constraint(equalTo: infoContainer.widthAnchor).isActive = true
            
        }
    }
    
}

extension MainViewController: ScrollSelectionViewDataSource {
    func numberOfItems(infinitiScrollSelectionView: ScrollSelectionView) -> Int {
        return expenseRecodeViewModel.itemsString.count
    }
    
    func titleForItem(infinitiScrollSelectionView: ScrollSelectionView, index: Int) -> String {
        return expenseRecodeViewModel.itemsString[index]
    }
    
}

extension MainViewController: ScrollSelectionViewDelegate {
    func scrollSelectionView(scrollSelectionView: ScrollSelectionView, didSelectIndexAt index: Int) {
        print(index)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "今天" : "8月27日"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5 : 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseRecodeTableViewCell.identifer, for: indexPath)
        
        guard let recodeCell = cell as? ExpenseRecodeTableViewCell else { return cell }
        return recodeCell
    }
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
}
