//
//  NoteGiphyTableViewCell.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/28.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import GiphyUISDK
import GiphyCoreSDK

struct NoteGiphyCellViewModel {
    let userImageURL: String?
    let userName: String
    let mediaID: String
    let time: String
}

class NoteGiphyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var giphyView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!

    let mediaView = GPHMediaView()
    
    var viewModel: NoteGiphyCellViewModel? {
        didSet {
            self.userImageView.setUrlImage(viewModel?.userImageURL ?? "")
            self.userNameLabel.text = viewModel?.userName
            self.timeLabel.text = viewModel?.time
            self.mediaView.media = nil
            loadGif(mediaID: viewModel?.mediaID ?? "")
        }
    }
    
    func loadGif(mediaID: String) {
        GiphyCore.shared.gifByID(mediaID) { (response, error) in
            if let media = response?.data {
                DispatchQueue.main.sync { [weak self] in
                    self?.mediaView.setMedia(media)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupMediaView()
    }
    
    func setupMediaView() {
        mediaView.contentMode = UIView.ContentMode.scaleToFill
        giphyView.addSubview(mediaView)
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        mediaView.topAnchor.constraint(equalTo: giphyView.topAnchor).isActive = true
        mediaView.bottomAnchor.constraint(equalTo: giphyView.bottomAnchor).isActive = true
        mediaView.leadingAnchor.constraint(equalTo: giphyView.leadingAnchor).isActive = true
        mediaView.trailingAnchor.constraint(equalTo: giphyView.trailingAnchor).isActive = true
        giphyView.layer.cornerRadius = 10
        giphyView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }

}
