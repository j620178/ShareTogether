//
//  TabView.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/30.
//  Copyright © 2019 littema. All rights reserved.

import UIKit

protocol TabViewDataSource: AnyObject {
//    func numberOfItems(tabView: TabView) -> Int
//    func imageForItem(tabView: TabView, index: Int) -> String
    func heightOfTabView(tabView: TabView) -> CGFloat
    //func contentOfTabView(tabView: TabView) -> UIView
}

extension TabViewDataSource {
    func heightOfTabView(tabView: TabView) -> CGFloat { return 60 }
}

@objc protocol TabViewDelegate: AnyObject {
    @objc optional func tabView(
        tabView: TabView,
        didSelectIndexAt index: Int)
}

class TabView: UIView {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    weak var dataSource: TabViewDataSource?
    
    weak var delegate: TabViewDelegate?
    
    var buttons = [UIButton]()
    
    var constraint: NSLayoutConstraint?
    
    private func setupBase() {
        
        self.backgroundColor = .white
        self.addCornerAndShadow(cornerRadius: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])

        setupItem()
    }
    
    private func setupItem() {
        //guard let dataSource = dataSource else { return }
        
//        for index in 0..<3 {
//            let button = UIButton()
//            button.translatesAutoresizingMaskIntoConstraints = false
//            let string = "123"
//            button.setTitle(string, for: .normal)
//            button.setTitleColor(.STBlack, for: .normal)
//            button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
//            //button.titleLabel?.font = dataSource.titleFontForItem(scrollSelectionView: self)
//            button.tag = index
//            buttons.append(button)
//
//            stackView.addArrangedSubview(button)
//        }
    }
    
    func showSelf(duration: TimeInterval, delay: TimeInterval) {
        constraint?.isActive = false
        constraint?.constant = -60
        constraint?.isActive = true
        superview?.layoutIfNeeded()
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: { [weak self] in
            self?.constraint?.isActive = false
            self?.constraint?.constant = 0
            self?.constraint?.isActive = true
            self?.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func tapButton(_ button: UIButton) {
        
        delegate?.tabView?(tabView: self, didSelectIndexAt: button.tag)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBase()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        setupBase()
    }
    
}
