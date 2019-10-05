//
//  SwiftIconFont.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/2.
//  Copyright © 2019 littema. All rights reserved.
//

import JGProgressHUD

class LKProgressHUD {

    static let shared = LKProgressHUD()

    private init() { }

    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.tintColor = .white
        return hud
    }()
    
    var view: UIView {
        guard let appDelegate = UIApplication.shared.delegate,
            let window = appDelegate.window,
            let realWindow = window,
            let rootVC = realWindow.rootViewController,
            let view = rootVC.view
        else {
            fatalError()
        }
                
        return view
    }

    static func show(type: Result<String, Error>) {

        switch type {

        case .success(let text):

            showSuccess(text: text)

        case .failure(let error):

            showFailure(text: error.localizedDescription)
        }
    }
    
    static func showLoading(text: String = "處理中", view: UIView? = shared.view) {
        
        guard let view = view else { return }

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showLoading(text: text, view: view)
            }

            return
        }
        
        shared.hud.textLabel.text = text

        shared.hud.show(in: view)

    }
    
    static func showSuccess(text: String = "Success", view: UIView? = shared.view) {
        
        guard let view = view else { return }

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showSuccess(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()

        shared.hud.show(in: view)

        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func showFailure(text: String = "Failure", view: UIView? = shared.view) {
        
        guard let view = view else { return }

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                showFailure(text: text)
            }

            return
        }

        shared.hud.textLabel.text = text

        shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()

        shared.hud.show(in: view)

        shared.hud.dismiss(afterDelay: 1.5)
    }

    static func show(view: UIView = shared.view) {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                show()
            }

            return
        }

        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()

        shared.hud.textLabel.text = "Loading"

        shared.hud.show(in: view)
    }

    static func dismiss() {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                dismiss()
            }

            return
        }

        shared.hud.dismiss(afterDelay: 1.5)
    }
}
