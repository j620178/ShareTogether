//
//  GroupViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

enum GroupType: Int {
    case add = 0
    case edit
}

protocol GroupVCCoordinatorDelegate: AnyObject {
    
    func didFinishEditGroupFrom(_ viewController: STBaseViewController)
    
    func didFinishAddGroupFrom(_ viewController: STBaseViewController)
    
    func showInviteViewControllerFrom(_ viewController: STBaseViewController, type: GroupType)
        
    func dismissAddGroupFrom(_ viewController: STBaseViewController)
    
    func dismissEditGroupFrom(_ viewController: STBaseViewController)
}

class GroupViewController: STBaseViewController {
    
    weak var coordinator: GroupVCCoordinatorDelegate?
    
    var viewModel: GroupViewModel?
    
    var type = GroupType.add
    
    var lastVelocityYSign = 0
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var bannerView: UIView!
        
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var bannerViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addMemberButton: UIButton!
    
    @IBOutlet weak var setCoverButton: UIButton! {
        didSet {
            setCoverButton.setImage(.getIcon(code: "ios-camera", color: .STDarkGray, size: 45), for: .normal)
            setCoverButton.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.registerWithNib(identifier: MemberTableViewCell.identifier)
        }
    }

    var currentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        switchShowType()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setCoverButton.layer.cornerRadius = setCoverButton.frame.height / 2
    }
    
    func setupUI() {
        addMemberButton.setImage(.getIcon(code: "md-person-add", color: .STTintColor, size: 30), for: .normal)

        coverImageView.layer.cornerRadius = 20
        coverImageView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        bannerView.addCornerAndShadow(cornerRadius: 20, maskedCorners: [.layerMaxXMaxYCorner])
        
        textField.layer.cornerRadius = 10.0
        textField.clipsToBounds = true
        textField.addLeftSpace()
    }
    
    func switchLayout(direction: Direction) {
        
        if direction == .up {
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                
                self?.bannerViewConstraint.constant = 360
                
                self?.textField.alpha = 1
                
                self?.setCoverButton.alpha = 1
                
                self?.title = ""
                
                self?.view.layoutIfNeeded()
                
            }
            
        } else if direction == .down {
            
            textField.resignFirstResponder()
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                
                self?.bannerViewConstraint.constant = 180
                
                self?.textField.alpha = 0
                
                self?.setCoverButton.alpha = 0
                
                self?.title = self?.textField.text
                
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    func switchShowType() {
        switch type {
            
        case .add:
            
            textField.isUserInteractionEnabled = true
            
            textField.becomeFirstResponder()
            
            let leftButton = UIButton(type: .custom)
            
            leftButton.addTarget(self, action: #selector(closeSelf(_:)), for: .touchUpInside)
            
            navigationItem.leftBarButtonItem = .customItem(button: leftButton, code: "ios-arrow-round-back")
            
            let rightButton = UIButton(type: .custom)
            
            rightButton.addTarget(self, action: #selector(addGroup(_:)), for: .touchUpInside)
            
            navigationItem.rightBarButtonItem = .customItem(button: rightButton, code: "ios-add")
            
            //members = [MemberInfo(userInfo: CurrentManager.shared.user!, status: 0)]
            
        case .edit:
            
            textField.isUserInteractionEnabled = false
            
            textField.text = CurrentManager.shared.group?.name
            
            coverImageView.setUrlImage(CurrentManager.shared.group?.coverURL ?? "")

            setCoverButton.isHidden = true
            
            let button = UIButton(type: .custom)
            
            button.addTarget(self, action: #selector(closeSelf(_:)), for: .touchUpInside)
            
            navigationItem.leftBarButtonItem = .customItem(button: button, code: "ios-close")
            
//            FirestoreManager.shared.getMembers { [weak self] result in
//                switch result {
//
//                case .success(let members):
//
//                    self?.members = members
//
//                case .failure(let error):
//
//                    print(error)
//                }
//            }
        }
    }
    
    func presentAlertController(text: String, member: MemberInfo) {
        
        FirestoreManager.shared.getUserGroups { [weak self] userGroups in

            guard let strongSelf = self else { return }
            
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            let action = UIAlertAction(title: text, style: .destructive) { _ in
                
                guard userGroups.count > 1
                else {
                    LKProgressHUD.showFailure(text: "無法退出最後一個群組", view: strongSelf.view)
                    return
                }
                
                FirestoreManager.shared.updateGroupMemberStatus(memberInfo: member,
                                                                status: .quit,
                                                                completion: { result in
                    switch result {
                        
                    case .success:
                        print("success")
                
                    case .failure:
                        print("error")
                    }
                })

            }
            
            controller.addAction(action)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            controller.addAction(cancelAction)
            
            strongSelf.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func closeSelf(_ sender: UIButton) {
        
        switch type {
   
        case .add:
            
            coordinator?.dismissAddGroupFrom(self)
            //navigationController?.popViewController(animated: true)
            
        case .edit:
            
            coordinator?.dismissEditGroupFrom(self)
            //dismiss(animated: true, completion: nil)
        }
    }

    @objc func addGroup(_ sender: UIButton) {
                
        guard let text = textField.text, text != "", let coverImage = coverImageView.image
        else {
            LKProgressHUD.showFailure(text: "請點選相機圖示上傳群組相片", view: self.view)
            return
        }
        
        LKProgressHUD.showLoading(view: self.view)
        
        viewModel?.addGroup(coverImage: coverImage, text: text, completion: { [weak self] result in
            
            LKProgressHUD.dismiss()
            
            guard let strongSelf = self else { return }
            
            switch result {

            case .success:
                
                strongSelf.coordinator?.didFinishAddGroupFrom(strongSelf)

            case .failure(let error):

                print(error)
            }
        })
    }
    
    @IBAction func clickAddMemberButton(_ sender: UIButton) {
        
        guard !CurrentManager.shared.isDemoGroup() else {
            LKProgressHUD.showFailure(text: "範例群組無法新增成員，請建立新群組", view: self.view)
            return
        }
        
        coordinator?.showInviteViewControllerFrom(self, type: type)
    }
    
    @IBAction func clickSetCoverButton(_ sender: UIButton) {
        
        let picker: UIImagePickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            picker.allowsEditing = true
            
            picker.delegate = self
            
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    @objc func gestureAction(_ sender: UITapGestureRecognizer) {
        
        switchLayout(direction: .up)
    }
    
    @objc func gestureDownAction(_ sender: UISwipeGestureRecognizer) {
        
        switchLayout(direction: .down)
    }
}

extension GroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.availableMembers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identifier, for: indexPath)
        
        guard let memberCell = cell as? MemberTableViewCell else { return cell}
        
        memberCell.viewModel = viewModel?.getCellViewModel(index: indexPath.row)
        
        return memberCell
    }
}

extension GroupViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentVelocityY =  scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        
        let currentVelocityYSign = Int(currentVelocityY).signum()
        
        if currentVelocityYSign != lastVelocityYSign,
            
            currentVelocityYSign != 0 {
        
            lastVelocityYSign = currentVelocityYSign
        }
        
        if lastVelocityYSign < 0 {
            
            switchLayout(direction: .down)
        }
        
        if scrollView.contentOffset.y < -50 {
            
            switchLayout(direction: .up)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if type == .edit {
            
            guard !CurrentManager.shared.isDemoGroup() else {
                
                LKProgressHUD.showFailure(text: "範例群組無法新增資料，請建立新群組", view: self.view)
                
                return
            }
            
            guard type == .edit, viewModel != nil else { return }
            
            if viewModel?.availableMembers[indexPath.row].id == CurrentManager.shared.user?.id {
                
                presentAlertController(text: "退出", member: viewModel!.availableMembers[indexPath.row])
                
            } else {
                
                presentAlertController(text: "刪除", member: viewModel!.availableMembers[indexPath.row])
            }
        }

    }

}

extension GroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        self.coverImageView.image = image.resizeImage(targetSize: CGSize(width: 1024, height: 768))
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
