//
//  MainViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class HomeViewController: STBaseViewController {
    
    enum InfoType: String {
        case expense = "交易紀錄"
        case statistics = "金額統計"
        case result = "結算結果"
        case notebook = "記事本"
    }
    
    let infoItems: [InfoType] = [.expense, .statistics, .result, .notebook]
    
    var currentGroup: GroupInfo? {
        didSet {
            if oldValue?.id != currentGroup?.id {
                viewModel.fectchData()
            }
        }
    }
    
    var expenseTableViewController: ExpenseViewController?
    
    var statisticsTableViewController: StatisticsViewController?
    
    var resultTableViewController: ResultViewController?
    
    var notebookTableViewController: NotebookViewController?
    
    var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var bannerTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoTypeSelectionView: ScrollSelectionView!
    
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var groupNameButton: UIButton! {
        didSet {
            groupNameButton.setImage(
                .getIcon(code: "ios-arrow-down", color: .white, size: 22),
                for: .normal
            )
            groupNameButton.setTitleColor(.white, for: .normal)
        }
    }
        
    @IBOutlet weak var editGroupButton: UIButton! {
        didSet {
            editGroupButton.setImage(.getIcon(code: "md-more", color: .white, size: 30), for: .normal)
        }
    }
    
    @IBOutlet weak var infoContainer: UIScrollView!
    
    @IBAction func clickGroupNameButton(_ sender: UIButton) {
        
        let nextVC = UIStoryboard.group.instantiateInitialViewController()!
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
        
    }
    
    @IBAction func clickEditGroupButton(_ sender: UIButton) {
        
        let groupStoryboard = UIStoryboard.group
        
        let navigationController = STNavigationController()
        
        guard let nextVC = groupStoryboard.instantiateViewController(
            withIdentifier: GroupViewController.identifier)
            as? GroupViewController
        else { return }
        
        nextVC.showType = .edit
        
        navigationController.viewControllers = [nextVC]
        
        present(navigationController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundLightGray
        bannerView.addShadow()
        bannerView.backgroundColor = .STTintColor
        
        infoContainer.delegate = self
        
        infoTypeSelectionView.dataSource = self
        infoTypeSelectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentGroup = UserInfoManager.shaered.currentGroupInfo
        groupNameButton.setTitle(UserInfoManager.shaered.currentGroupInfo?.name, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let expenseVC = segue.destination as? ExpenseViewController {
            expenseVC.delegate = self
            expenseVC.viewModel = viewModel
            expenseTableViewController = expenseVC
        } else if let statisticsVC = segue.destination as? StatisticsViewController {
            statisticsVC.delegate = self
            statisticsVC.viewModel = viewModel
            statisticsTableViewController = statisticsVC
        } else if let resultVC = segue.destination as? ResultViewController {
            resultVC.delegate = self
            resultVC.viewModel = viewModel
            resultTableViewController = resultVC
        } //else if let notebookVC = segue.destination as? NotebookTableViewController {
//            notebookVC.delegate = self
//            notebookTableViewController = notebookVC
//        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        emptyView.alpha = 0
        
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
        infoContainer.setContentOffset(CGPoint(x: index * Int(UIScreen.main.bounds.width), y: 0), animated: true)
    }
}

extension HomeViewController: HomeViewControllerDelegate {
    
    func empty(isEmpty: Bool) {
        if isEmpty {
            emptyView.alpha = 1
        } else {
            emptyView.alpha = 0
        }
    }
    
    func tableViewDidScroll(viewController: UIViewController, offsetY: CGFloat) {
        let offset = min(max(offsetY, 0), 65)
    
        groupNameButton.alpha = 1 - (offset / 65)
        editGroupButton.alpha = 1 - (offset / 65)
        bannerTopConstraint.constant = 20 - offset
        view.layoutIfNeeded()
    }

}
