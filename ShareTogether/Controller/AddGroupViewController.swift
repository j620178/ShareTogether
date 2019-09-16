//
//  AddGroupViewController.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/3.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class AddGroupViewController: STBaseViewController {
    
    let userNames = ["Pony", "Tiffany", "Jun", "Rita", "Evan", "Vickey", "Hanru", "Emma", "Hazel"]
    
    var lastVelocityYSign = 0
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var groupMemberView: UIView!
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
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
        
        addMemberButton.setImage(.getIcon(code: "ios-add-circle-outline", color: .STTintColor, size: 30), for: .normal)

        bannerImageView.layer.cornerRadius = 20
        bannerImageView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        bannerView.addCornerAndShadow(cornerRadius: 20, maskedCorners: [.layerMaxXMaxYCorner])
        
        groupNameTextField.delegate = self
        groupNameTextField.layer.cornerRadius = 10.0
        groupNameTextField.clipsToBounds = true
        groupNameTextField.becomeFirstResponder()
        groupNameTextField.addLeftSpace()

        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let barItem = UIBarButtonItem(image: .getIcon(code: "ios-add", color: .white, size: 40),
                                      style: .plain,
                                      target: self,
                                      action: nil)
        
        navigationItem.rightBarButtonItem = barItem
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setCoverButton.layer.cornerRadius = setCoverButton.frame.height / 2
    }
    
    func switchLayout(direction: Direction) {
        if direction == .up {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.bannerViewConstaint.constant = 360
                self?.groupNameTextField.alpha = 1
                self?.setCoverButton.alpha = 1
                self?.title = ""
                self?.view.layoutIfNeeded()
            }
        } else if direction == .down {
            groupNameTextField.resignFirstResponder()
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.bannerViewConstaint.constant = 180
                self?.groupNameTextField.alpha = 0
                self?.setCoverButton.alpha = 0
                self?.title = self?.groupNameTextField.text
                self?.view.layoutIfNeeded()
            }
        }
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
        print(123)
    }
}

extension AddGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identifer, for: indexPath)
        
        guard let memberCell = cell as? MemberTableViewCell else { return cell}
        
        memberCell.userNameLabel.text = userNames[indexPath.row]
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil) // 關掉
        self.bannerImageView.image = info[.originalImage] as? UIImage // 從Dictionary取出原始圖檔
    }
    
    // 圖片picker控制器任務結束回呼
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
