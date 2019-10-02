//
//  MainViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class HomeViewController: STBaseViewController {
    
    override var isHideNavigationBar: Bool {
        return true
    }
    
    enum InfoType: String {
        case expense = "交易紀錄"
        case statistics = "金額統計"
        case result = "結算結果"
        case notebook = "記事本"
    }
    
    let infoItems: [InfoType] = [.expense, .statistics, .result, .notebook]
    
    var expenseTableViewController: ExpenseViewController?
    
    var statisticsTableViewController: StatisticsViewController?
    
    var resultTableViewController: ResultViewController?
    
    var notebookTableViewController: NoteViewController?
    
    var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var bannerTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoTypeSelectionView: ScrollSelectionView!
        
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
    
    @IBOutlet weak var infoScrollView: UIScrollView!
    
    @IBAction func clickGroupNameButton(_ sender: UIButton) {
        
        let nextVC = UIStoryboard.group.instantiateInitialViewController()!
        present(nextVC, animated: true, completion: nil)
        
    }
    
    @IBAction func clickEditGroupButton(_ sender: UIButton) {
                
        let navigationController = STNavigationController()
        
        guard let nextVC = UIStoryboard.group.instantiateViewController(
            withIdentifier: GroupViewController.identifier)
            as? GroupViewController
        else { return }
        
        nextVC.showType = .edit
        
        navigationController.viewControllers = [nextVC]
        
        present(navigationController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")

        bannerView.addShadow()
        bannerView.backgroundColor = .STTintColor
        
        infoScrollView.delegate = self
        
        infoTypeSelectionView.dataSource = self
        infoTypeSelectionView.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(upadateCurrentGroup),
                                               name: NSNotification.Name(rawValue: "CurrentGroup"),
                                               object: nil)

        upadateCurrentGroup()
            
    }
    
    @objc func upadateCurrentGroup() {
        viewModel.fectchData()
        groupNameButton.setTitle(CurrentManager.shared.group?.name, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        } else if let notebookVC = segue.destination as? NoteViewController {
            notebookVC.delegate = self
            notebookTableViewController = notebookVC
        }
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
        infoScrollView.setContentOffset(CGPoint(x: index * Int(UIScreen.main.bounds.width), y: 0), animated: true)
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
