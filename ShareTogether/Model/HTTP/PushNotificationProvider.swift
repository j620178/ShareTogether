//
//  PushNotificationProvider.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/2.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

struct PushRespond: Codable {
    let multicastID: Double
    let success, failure, canonicalIDS: Int
    let results: [PushResult]

    enum CodingKeys: String, CodingKey {
        case multicastID = "multicast_id"
        case success, failure
        case canonicalIDS = "canonical_ids"
        case results
    }
}

struct PushResult: Codable {
    let messageID: String

    enum CodingKeys: String, CodingKey {
        case messageID = "message_id"
    }
}

class PushNotificationProvider {
    
    func send(to token: String,
              title: String?,
              body: String?,
              expenseID: String?,
              badge: Int,
              completion: ((Result<PushRespond, Error>) -> Void)?) {
        
        HTTPClinet
            .shared
            .request(PushNotification.send(token: token, title: title, body: body, expenseID: expenseID, badge: badge)) { result in
                
                switch result {
                    
                case .success(let data):
                    
                    do {
                        
                        let pushRespond = try JSONDecoder().decode(PushRespond.self, from: data)
                        
                        DispatchQueue.main.async {
                            
                            completion?(Result.success(pushRespond))
                            
                        }
                        
                    } catch {
                        
                        completion?(Result.failure(error))
                        
                    }
                case .failure(let error):
                    
                    completion?(Result.failure(error))
                    
                }
        }
        
    }
    
}
