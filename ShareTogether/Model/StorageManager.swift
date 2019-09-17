//
//  StorageManager.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/16.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageManager {
    static let shared = StorageManager()
    
    let storage = Storage.storage()
    
    func uploadImage(image: UIImage, completion: @escaping (String) -> Void) {
        
        guard let groupID = UserInfoManager.shaered.currentGroup?.id,
            let uploadData = image.fixOrientation().pngData()
        else { return }
            
        let storageRef = storage.reference().child("GroupCover").child("\(groupID).png")

        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            //let size = metadata!.size

            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                // Uh-oh, an error occurred!
                return
                }
                completion(downloadURL.absoluteString)
            }
            
        }
        
    }
    
}
