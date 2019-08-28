//
//  InfinitiScrollSelectionView.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/28.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol ScrollSelectionViewDataSource: AnyObject {
    func numberOfItems(infinitiScrollSelectionView: ScrollSelectionView) -> Int
    func titleForItem(infinitiScrollSelectionView: ScrollSelectionView, index: Int) -> String
}

@objc protocol ScrollSelectionViewDelegate {
    @objc func scrollSelectionView(
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
        view.backgroundColor = .STBlack
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
    
    var currentSelect: (index: Int, button: UIButton)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        //fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
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
    
    func setupItem() {
        guard let dataSource = dataSource else { return }
        
        for index in 0..<dataSource.numberOfItems(infinitiScrollSelectionView: self) {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            let string = dataSource.titleForItem(infinitiScrollSelectionView: self, index: index)
            button.widthAnchor.constraint(equalToConstant: getSizeFromString(string: string).width + 20).isActive = true
            button.setTitle(string, for: .normal)
            button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
            button.tag = index
            buttons.append(button)
            
            if index == 0 {
                currentSelect = (index: index, button: button)
            }
            
            stackView.addArrangedSubview(button)
        }
    }
    
    func getSizeFromString(string: String, withFont font: UIFont = .systemFont(ofSize: 15)) -> CGSize {
        let textSize = NSString(string: string).size(withAttributes: [NSAttributedString.Key.font: font])
        return textSize
    }
    
    func updateSelectedItem(button: UIButton) {
        indicator.center.x = button.center.x
    }
    
    @objc func tapButton(_ button: UIButton) {
        
        delegate?.scrollSelectionView(scrollSelectionView: self, didSelectIndexAt: button.tag)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            for button in strongSelf.buttons {
                button.setTitleColor(.STGray, for: .normal)
            }
            
            self?.updateSelectedItem(button: button)
            button.setTitleColor(.STBlack, for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicator.layer.cornerRadius = dotSize / 2
        
        scrollView.layoutIfNeeded()
        
        guard let currentSelect = currentSelect else { return }
        
        indicator.frame = CGRect(x: 0, y: scrollView.center.y + 18, width: dotSize, height: dotSize)
        scrollView.addSubview(indicator)
        
        tapButton(currentSelect.button)
    }
    
}
