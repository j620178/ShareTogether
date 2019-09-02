//
//  STTabView.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/30.
//  Copyright © 2019 littema. All rights reserved.

import UIKit

protocol STTabViewDataSource: AnyObject {
    func numberOfItems(STTabView: STTabView) -> Int
    func imageForItem(STTabView: STTabView, index: Int) -> String
    func heightOfContent(STTabView: STTabView) -> CGFloat
}

extension STTabViewDataSource {
    func heightOfContent(tabView: STTabView) -> Int { return 50 }
}

@objc protocol STTabViewDelegate: AnyObject {
    @objc optional func tabView(
        tabView: STTabView,
        didSelectIndexAt index: Int)
}

class STTabView: UIView {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    weak var dataSource: STTabViewDataSource?
//        {
//        didSet {
//            setupBase()
//        }
//    }
    
    weak var delegate: STTabViewDelegate?
    
    var buttons = [UIButton]()
    
    var constraint: NSLayoutConstraint?
    
    private func setupBase() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20.0
        self.layer.maskedCorners = [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner]
        
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        
        self.addSubview(stackView)
        
        constraint = NSLayoutConstraint(item: layoutMarginsGuide, attribute: .bottom, relatedBy: .equal,
                                        toItem: stackView, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            constraint!
        ])
    
        setupItem()
    }
    
    private func setupItem() {
        //guard let dataSource = dataSource else { return }
        
        for index in 0..<3 {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            let string = "123"
            button.setTitle(string, for: .normal)
            button.setTitleColor(.STBlack, for: .normal)
            button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
            //button.titleLabel?.font = dataSource.titleFontForItem(scrollSelectionView: self)
            button.tag = index
            buttons.append(button)
            
            stackView.addArrangedSubview(button)
        }
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
