//
//  MainViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

private enum InfoType: String {
    case expense = "交易紀錄"
    case statistics = "金額統計"
    case result = "結算結果"
    case notebook = "記事本"
}

protocol HomeVCCoordinatorDelegate: AnyObject {
    
    func showGroupListFrom(_ viewController: STBaseViewController)
    
    func showEditGroupFrom(_ viewController: STBaseViewController)
    
}

class HomeViewController: STBaseViewController {
    
    override var isHideNavigationBar: Bool { return true }
    
    weak var coordinator: HomeVCCoordinatorDelegate?
    
    var viewModel: HomeViewModel?

    private let infoItems: [InfoType] = [.expense, .statistics, .result, .notebook]
    
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var bannerTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoTypeSelectionView: ScrollSelectionView!
        
    @IBOutlet weak var groupNameButton: UIButton! {
        didSet {
            groupNameButton.setImage(
                .getIcon(code: "ios-arrow-down", color: .white, size: 22),
                for: .normal)
            
            groupNameButton.setTitleColor(.white, for: .normal)
        }
    }
        
    @IBOutlet weak var editGroupButton: UIButton! {
        didSet {
            editGroupButton.setImage(.getIcon(code: "md-more", color: .white, size: 30), for: .normal)
        }
    }
    
    @IBOutlet weak var infoScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bannerView.addShadow()
        
        bannerView.backgroundColor = .STTintColor
        
        infoScrollView.delegate = self
        
        infoTypeSelectionView.dataSource = self
        
        infoTypeSelectionView.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCurrentGroup),
                                               name: NSNotification.Name(rawValue: "CurrentGroup"),
                                               object: nil)

        updateCurrentGroup()
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let expenseVC = segue.destination as? ExpenseViewController {
            
            expenseVC.delegate = self
            
            expenseVC.viewModel = viewModel
            
        } else if let statisticsVC = segue.destination as? StatisticsViewController {
            
            statisticsVC.delegate = self
            
            statisticsVC.viewModel = viewModel
            
        } else if let resultVC = segue.destination as? ResultViewController {
            
            resultVC.delegate = self
            
            resultVC.viewModel = viewModel
            
        } else if let notebookVC = segue.destination as? NoteViewController {
            
            notebookVC.delegate = self
        }
    }
    
    @IBAction func clickGroupNameButton(_ sender: UIButton) {
        
        coordinator?.showGroupListFrom(self)
    }
    
    @IBAction func clickEditGroupButton(_ sender: UIButton) {
                
        coordinator?.showEditGroupFrom(self)
    }
    
    @objc func updateCurrentGroup() {
        
        viewModel?.fetchData()
        
        groupNameButton.setTitle(CurrentManager.shared.group?.name, for: .normal)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let screenPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        
        if screenPage > infoTypeSelectionView.selectIndex {
            
            infoTypeSelectionView.switchIndicatorAt(index: screenPage)
            
        } else if screenPage < infoTypeSelectionView.selectIndex {
            
            infoTypeSelectionView.switchIndicatorAt(index: screenPage)
        }
    }
}

extension HomeViewController: ScrollSelectionViewDataSource {
    
    func numberOfItems(scrollSelectionView: ScrollSelectionView) -> Int {
        
        return infoItems.count
    }
    
    func titleForItem(scrollSelectionView: ScrollSelectionView, index: Int) -> String {
        
        return infoItems[index].rawValue
    }
}

extension HomeViewController: ScrollSelectionViewDelegate {
    
    func scrollSelectionView(scrollSelectionView: ScrollSelectionView, didSelectIndexAt index: Int) {
        
        let index = infoTypeSelectionView.selectIndex
        
        let xPos = index * Int(UIScreen.main.bounds.width)
        
        infoScrollView.setContentOffset(CGPoint(x: xPos, y: 0), animated: true)
    }
}

extension HomeViewController: HomeViewControllerDelegate {
    
    func tableViewDidScroll(viewController: UIViewController, offsetY: CGFloat, contentSize: CGSize) {
        
        if contentSize.height > UIScreen.main.bounds.height - 120 {
            
            let offset = min(max(offsetY, 0), 65)
        
            groupNameButton.alpha = 1 - (offset / 65)
            
            editGroupButton.alpha = 1 - (offset / 65)
            
            bannerTopConstraint.constant = 20 - offset
            
            view.layoutIfNeeded()
            
        } else {
            
            groupNameButton.alpha = 1
            
            editGroupButton.alpha = 1
            
            bannerTopConstraint.constant = 20
        }
    }
}
