//
//  InfinitiScrollSelectionView.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol ScrollSelectionViewDataSource: AnyObject {
    func numberOfItems(scrollSelectionView: ScrollSelectionView) -> Int
    func titleForItem(scrollSelectionView: ScrollSelectionView, index: Int) -> String
    func titleFontForItem(scrollSelectionView: ScrollSelectionView) -> UIFont
    func colorOfTitleForItem(scrollSelectionView: ScrollSelectionView) -> UIColor
}

extension ScrollSelectionViewDataSource {
    
    func titleFontForItem(scrollSelectionView: ScrollSelectionView) -> UIFont {
        return .systemFont(ofSize: 14, weight: .medium)
    }
    
    func colorOfTitleForItem(scrollSelectionView: ScrollSelectionView) -> UIColor {
        return .white
    }
    
}

@objc protocol ScrollSelectionViewDelegate {
    @objc optional func scrollSelectionView(
        scrollSelectionView: ScrollSelectionView,
        didSelectIndexAt index: Int)
}

class ScrollSelectionView: UIView {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20.0
        return stackView
    }()
    
    let indicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    weak var dataSource: ScrollSelectionViewDataSource? {
        didSet {
            setupItem()
        }
    }
    
    weak var delegate: ScrollSelectionViewDelegate?
    
    var dotSize: CGFloat = 5
    
    var buttons = [UIButton]()
    
    var selectIndex = 0
    
    private func setupBase() {
        
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

    }
    
    private func setupItem() {
        guard let dataSource = dataSource else { return }
        
        for index in 0..<dataSource.numberOfItems(scrollSelectionView: self) {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            let string = dataSource.titleForItem(scrollSelectionView: self, index: index)
            button.widthAnchor.constraint(equalToConstant: string.getSizeFromString().width + 10).isActive = true
            button.setTitle(string, for: .normal)
            button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
            button.titleLabel?.font = dataSource.titleFontForItem(scrollSelectionView: self)
            button.tag = index
            buttons.append(button)
            
            stackView.addArrangedSubview(button)
        }
        
        scrollView.addSubview(indicator)
        indicator.layer.cornerRadius = dotSize / 2
        indicator.frame = CGRect(x: 0, y: self.frame.height - dotSize, width: dotSize, height: dotSize)
       
    }
    
    @objc private func tapButton(_ button: UIButton) {
        
        selectIndex = button.tag
        delegate?.scrollSelectionView?(scrollSelectionView: self, didSelectIndexAt: button.tag)
        switchIndicatorAt(index: button.tag)
        
    }
    
    func switchIndicatorAt(index: Int) {
        selectIndex = index
        UIView.animate(withDuration: 0.5) { [weak self] in
            
            guard let strongSelf = self, let dataSource = self?.dataSource else { return }
            
            for button in strongSelf.buttons {
                button.setTitleColor(dataSource.colorOfTitleForItem(scrollSelectionView: strongSelf).withAlphaComponent(0.25), for: .normal)
            }
            
            strongSelf.buttons[index].setTitleColor(dataSource.colorOfTitleForItem(scrollSelectionView: strongSelf), for: .normal)
            strongSelf.indicator.center.x = strongSelf.buttons[index].center.x
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBase()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBase()
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.layoutIfNeeded()
        
        switchIndicatorAt(index: buttons[selectIndex].tag)
    
    }
    
}
