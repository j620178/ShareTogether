//
//  GroupViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

enum ShowType {
    case new
    case edit
}

class GroupViewController: STBaseViewController {
    
    var showType = ShowType.new
    
    var members = [MemberInfo]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var availableMembers: [MemberInfo] {
        var availableMembers = [MemberInfo]()
        
        for member in members {
            if MemberStatusType.init(rawValue: member.status) == MemberStatusType.quit ||
                MemberStatusType.init(rawValue: member.status) == MemberStatusType.archive {
            } else {
                availableMembers.append(member)
            }
        }
        
        return availableMembers
    }
    
    var lastVelocityYSign = 0
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var bannerView: UIView!
        
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var bannerViewConstaint: NSLayoutConstraint!
    
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
            tableView.registerWithNib(indentifer: MemberTableViewCell.identifer)
        }
    }
    
    @IBAction func clickAddMemberButton(_ sender: UIButton) {
        if showType == .edit {
            let demoGroupID = Bundle.main.object(forInfoDictionaryKey: "DemoGroupID") as? String
            
            if demoGroupID == UserInfoManager.shaered.currentGroupInfo?.id {
                LKProgressHUD.showFailure(text: "範例群組無法新增成員，請建立新群組", view: self.view)
                return
            }
            
            guard let nextVC = UIStoryboard.group.instantiateViewController(identifier: InviteViewController.identifier)
                as? InviteViewController
            else { return }
            
            nextVC.showType = .edit
            navigationController?.pushViewController(nextVC, animated: true)
            
        } else if showType == .new {
            
            guard let nextVC = UIStoryboard.group.instantiateViewController(identifier: InviteViewController.identifier)
                as? InviteViewController
            else { return }
            
            navigationController?.pushViewController(nextVC, animated: true)

        }
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
                self?.bannerViewConstaint.constant = 360
                self?.textField.alpha = 1
                self?.setCoverButton.alpha = 1
                self?.title = ""
                self?.view.layoutIfNeeded()
            }
        } else if direction == .down {
            textField.resignFirstResponder()
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.bannerViewConstaint.constant = 180
                self?.textField.alpha = 0
                self?.setCoverButton.alpha = 0
                self?.title = self?.textField.text
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    func switchShowType() {
        switch showType {
            
        case .new:
            textField.isUserInteractionEnabled = true
            textField.becomeFirstResponder()
            
            let leftButton = UIButton(type: .custom)
            leftButton.addTarget(self, action: #selector(closeSelf(_:)), for: .touchUpInside)
            navigationItem.leftBarButtonItem = .customItem(button: leftButton, code: "ios-arrow-round-back")
            
            let rightButton = UIButton(type: .custom)
            rightButton.addTarget(self, action: #selector(addGroup(_:)), for: .touchUpInside)
            navigationItem.rightBarButtonItem = .customItem(button: rightButton, code: "ios-add")
            
            members = [MemberInfo(userInfo: UserInfoManager.shaered.currentUserInfo!, status: 0)]
            
        case .edit:
            textField.isUserInteractionEnabled = false
            textField.text = UserInfoManager.shaered.currentGroupInfo?.name
            coverImageView.setUrlImage(UserInfoManager.shaered.currentGroupInfo?.coverURL ?? "")

            setCoverButton.isHidden = true
            
            let button = UIButton(type: .custom)
            button.addTarget(self, action: #selector(closeSelf(_:)), for: .touchUpInside)
            navigationItem.leftBarButtonItem = .customItem(button: button, code: "ios-close")
            
            FirestoreManager.shared.getMembers { [weak self] result in
                switch result {
                    
                case .success(let members):
                    self?.members = members
                case .failure(let error):
                    print(error)
                }
            }
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
        
        switch showType {
   
        case .new:
            navigationController?.popViewController(animated: true)
        case .edit:
            dismiss(animated: true, completion: nil)
        }
        
    }

    @objc func addGroup(_ sender: UIButton) {
                
        guard let text = textField.text, text != "", coverImageView.image != nil
        else {
            LKProgressHUD.showFailure(text: "請點選相機圖示上傳群組相片", view: self.view)
            return
        }
        
        LKProgressHUD.showLoading(view: self.view)
        
        StorageManager.shared.uploadImage(image: coverImageView.image!) { [weak self] urlString in
            
            guard let strongSelf = self else { return }
            
            let groupInfo = GroupInfo(id: nil, name: text, coverURL: urlString, status: nil)

            FirestoreManager.shared.addGroup(groupInfo: groupInfo, members: strongSelf.members, completion: { result in
                switch result {
                case .success:
                    strongSelf.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                }
                LKProgressHUD.dismiss()
            })
            
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
        return availableMembers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identifer, for: indexPath)
        
        guard let memberCell = cell as? MemberTableViewCell else { return cell}
        
        memberCell.userImageView.setUrlImage(availableMembers[indexPath.row].photoURL)
        
        memberCell.userNameLabel.text = availableMembers[indexPath.row].name
        
        memberCell.detailLabel.text = MemberStatusType(rawValue: availableMembers[indexPath.row].status)?.getString
        
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
        
        if showType == .edit {
            let demoGroupID = Bundle.main.object(forInfoDictionaryKey: "DemoGroupID") as? String
            
            if demoGroupID == UserInfoManager.shaered.currentGroupInfo?.id {
                LKProgressHUD.showFailure(text: "範例群組無法新增資料，請建立新群組", view: self.view)
                return
            }
            
            guard showType == .edit else { return }
            
            if availableMembers[indexPath.row].id == UserInfoManager.shaered.currentUserInfo?.id {
                presentAlertController(text: "退出", member: availableMembers[indexPath.row])
            } else {
                presentAlertController(text: "刪除", member: availableMembers[indexPath.row])
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

extension UIBarButtonItem {
    
    static func customItem(button: UIButton, code: String) -> UIBarButtonItem {
        button.setImage(.getIcon(code: code, color: .STDarkGray, size: 40), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        return UIBarButtonItem(customView: button)
    }

}
