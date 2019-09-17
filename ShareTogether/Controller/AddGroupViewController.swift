//
//  AddGroupViewController.swift
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

class AddGroupViewController: STBaseViewController {
    
//    override var isHideNavigationBar: Bool {
//
//        return true
//    }
    
    var showType = ShowType.new
    
    var memberData = [MemberInfo]() {
        didSet {
            tableView.reloadData()
        }
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
        addMemberButton.setImage(.getIcon(code: "ios-add-circle-outline", color: .STTintColor, size: 30), for: .normal)

        coverImageView.layer.cornerRadius = 20
        coverImageView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        bannerView.addCornerAndShadow(cornerRadius: 20, maskedCorners: [.layerMaxXMaxYCorner])
        
        textField.delegate = self
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
            
//            setCoverButton.isHidden = false
//
//            let rightItem = UIBarButtonItem(title: "新增", style: .plain, target: self, action: #selector(addGroup(_:)))
//            navigationItem.rightBarButtonItem = rightItem
            
            let leftButton = UIButton(type: .custom)
            leftButton.addTarget(self, action: #selector(closeSelf(_:)), for: .touchUpInside)
            navigationItem.leftBarButtonItem = .customItem(button: leftButton, code: "ios-arrow-round-back")
            
            let rightButton = UIButton(type: .custom)
            rightButton.addTarget(self, action: #selector(addGroup(_:)), for: .touchUpInside)
            navigationItem.rightBarButtonItem = .customItem(button: rightButton, code: "ios-add")
            
            memberData = [MemberInfo(userInfo: UserInfoManager.shaered.currentUserInfo!, status: 0)]
            
        case .edit:
            textField.isUserInteractionEnabled = false
            textField.text = UserInfoManager.shaered.currentGroup?.name
            coverImageView.setUrlImage(UserInfoManager.shaered.currentGroup!.coverURL)

            setCoverButton.isHidden = true
            
            let button = UIButton(type: .custom)
            button.addTarget(self, action: #selector(closeSelf(_:)), for: .touchUpInside)
            navigationItem.leftBarButtonItem = .customItem(button: button, code: "ios-close")
            
            FirestoreManager.shared.getMembers { [weak self] result in
                switch result {
                    
                case .success(let members):
                    self?.memberData = members
                case .failure(let error):
                    print(error)
                }
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if showType == .edit {
            guard let nextVC = segue.destination as? InviteViewController else { return }
            nextVC.showType = .edit
        }
    }

    @objc func addGroup(_ sender: UIButton) {
        
        guard let text = textField.text, text != "" else { return }
            
        StorageManager.shared.uploadImage(image: coverImageView.image!) { [weak self] urlString in
            
            let groupInfo = GroupInfo(id: nil,
                                      name: text,
                                      coverURL: urlString,
                                      expenses: nil,
                                      members: self?.memberData)
            
            FirestoreManager.shared.addGroup(groupInfo: groupInfo, completion: { [weak self] result in
                switch result {
                case .success:
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                }
            })
            
        }
        
    }
    
    @objc func addMember(_ sender: UIButton) {
            
    }
    
    @objc func gestureAction(_ sender: UITapGestureRecognizer) {
        switchLayout(direction: .up)
    }
    
    @objc func gestureDownAction(_ sender: UISwipeGestureRecognizer) {
        switchLayout(direction: .down)
    }
    
}

extension AddGroupViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}

extension AddGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identifer, for: indexPath)
        
        guard let memberCell = cell as? MemberTableViewCell else { return cell}
        
        memberCell.userImageView.setUrlImage(memberData[indexPath.row].photoURL)
        
        memberCell.userNameLabel.text = memberData[indexPath.row].name
        
        memberCell.detailLabel.text = MemberStatusType(rawValue: memberData[indexPath.row].status)?.getString
        
        return memberCell
        
    }
        
}

extension AddGroupViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentVelocityY =  scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        let currentVelocityYSign = Int(currentVelocityY).signum()
        if currentVelocityYSign != lastVelocityYSign,
            currentVelocityYSign != 0 {
            lastVelocityYSign = currentVelocityYSign
        }
        
        if lastVelocityYSign < 0 {
            switchLayout(direction: .down)
        } else if lastVelocityYSign > 0 {
            //switchLayout(direction: .up)
        }
        
        if scrollView.contentOffset.y < -50 {
            switchLayout(direction: .up)
        }
    }

}

extension AddGroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
