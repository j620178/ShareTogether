//
//  SelectionView.swift
//  SelectionViewDemo
//
//  Created by littlema on 2019/8/19.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

protocol SelectionViewDataSource: AnyObject {
    
    func numberOfSelectionButtons(selectionView: SelectionView) -> Int
    
    func titleOfRowAt(selectionView: SelectionView, index: Int) -> String
    
    func indicatorColorOfSelectionButtons(selectionView: SelectionView) -> UIColor
    
    func titleColorOfSelectionButtons(selectionView: SelectionView, index: Int) -> UIColor
    
    func backgroundColorOfSelectionButtons(selectionView: SelectionView, index: Int) -> UIColor
    
    func fontOfSelectionButtons(selectionView: SelectionView, index: Int) -> UIFont
    
}

extension SelectionViewDataSource {
    
    func numberOfSelectionButtons(selectionView: SelectionView) -> Int {
        return 2
    }
    
    func indicatorColorOfSelectionButtons(selectionView: SelectionView) -> UIColor {
        return .white
    }
    
    func titleColorOfSelectionButtons(selectionView: SelectionView, index: Int) -> UIColor {
        return .white
    }
    
    func backgroundColorOfSelectionButtons(selectionView: SelectionView, index: Int) -> UIColor {
        return .black
    }
    
    func fontOfSelectionButtons(selectionView: SelectionView, index: Int) -> UIFont {
        return .systemFont(ofSize: 15, weight: .bold)
    }
    
}

@objc protocol SelectionViewDelegate {
    
    @objc optional func didSelectButton(selectionView: SelectionView, index: Int)
    
    @objc optional func shouldSelectButton(selectionView: SelectionView, index: Int) -> Bool
    
}

class SelectionView: UIView {

    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let indicatorContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let indicatorView = UIView()
    
    weak var dataSource: SelectionViewDataSource? {
        didSet {
            if dataSource != nil {
                setupButton()
            } else {
                reloadData()
            }
        }
    }
    
    weak var delegate: SelectionViewDelegate?
    // refator
    var currentIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBaseView()
    }
    
    func setupBaseView() {
        
        self.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            self.leftAnchor.constraint(equalTo: buttonStackView.leftAnchor),
            self.rightAnchor.constraint(equalTo: buttonStackView.rightAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: self.frame.height)
        ])

        self.addSubview(indicatorContainerView)
        NSLayoutConstraint.activate([
            buttonStackView.bottomAnchor.constraint(equalTo: indicatorContainerView.bottomAnchor),
            self.leftAnchor.constraint(equalTo: indicatorContainerView.leftAnchor),
            self.rightAnchor.constraint(equalTo: indicatorContainerView.rightAnchor),
            indicatorContainerView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
    }
    
    func setupButton() {

        guard let dataSource = dataSource else { return }
        
        indicatorView.backgroundColor = dataSource.indicatorColorOfSelectionButtons(selectionView: self)

        for index in 0..<dataSource.numberOfSelectionButtons(selectionView: self) {
            let button = UIButton()
            
            button.tag = index

            indicatorContainerView.backgroundColor = dataSource.backgroundColorOfSelectionButtons(selectionView: self, index: index)
            
            button.setTitle(dataSource.titleOfRowAt(selectionView: self, index: index), for: .normal)
            
            button.titleLabel?.font = dataSource.fontOfSelectionButtons(selectionView: self, index: index)
        button.setTitleColor(dataSource.titleColorOfSelectionButtons(selectionView: self, index: index), for: .normal)
            
            button.backgroundColor = dataSource.backgroundColorOfSelectionButtons(selectionView: self, index: index)
            
            button.addTarget(self, action: #selector(updataIndicatorPosition(_:)), for: .touchUpInside)
            
            buttonStackView.addArrangedSubview(button)
        }
        
        indicatorContainerView.addSubview(indicatorView)
    }
    
    func reloadData() {
        
        buttonStackView.subviews.forEach { $0.removeFromSuperview() }
        
        indicatorView.removeFromSuperview()
        
        setupButton()
        
        resetIndicatorPosition()
    }
    
    func resetIndicatorPosition() {
        
        buttonStackView.layoutIfNeeded()
        
        if buttonStackView.subviews.count > 0 {
            
            currentIndex = 0
            
            guard let firstView = buttonStackView.subviews.first,
                let btn = firstView as? UIButton,
                let btnLabel = btn.titleLabel,
                let text = btnLabel.text
                else { return }
            
            let width = text.getSizeFromString().width + 20
            
            indicatorView.frame = CGRect(x: btn.center.x - (width / 2), y: 0, width: width, height: 2)
            
            guard let delegate = delegate else { return }
            
            delegate.didSelectButton?(selectionView: self, index: 0)
        }
        
    }
    
    @objc func updataIndicatorPosition(_ button: UIButton) {
        
        currentIndex = button.tag
        
        guard let btnLabel = button.titleLabel, let text = btnLabel.text else { return }
        
        let width = text.getSizeFromString().width + 20
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            
            self?.indicatorView.frame = CGRect(x: button.center.x - (width / 2), y: 0, width: width, height: 2)
            
        }
        
        guard let delegate = delegate else { return }

        if delegate.shouldSelectButton?(selectionView: self, index: button.tag) != false {
            
            delegate.didSelectButton?(selectionView: self, index: button.tag)
        }
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        resetIndicatorPosition()
        
    }
    
}
