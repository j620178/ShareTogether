//
//  Amount.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/14.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MapKit

struct Expense: Codable {
    var id: String!
    let type: Int
    let desc: String
    let userID: String
    let amount: Double
    let payerInfo: AmountInfo
    let splitInfo: AmountInfo
    let position: GeoPoint
    let time: Timestamp
    
    init(type: Int, desc: String, userID: String, amount: Double,
         payerInfo: AmountInfo, splitInfo: AmountInfo, location: CLLocationCoordinate2D, time: Date) {
        
        self.userID = userID
        self.type = type
        self.amount = amount
        self.desc = desc
        self.payerInfo = payerInfo
        self.splitInfo = splitInfo
        self.position = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        self.time = Timestamp(date: time)
        
    }
}

struct AmountInfo: Codable {
    
    var type: Int
    
    var amountDesc: [AmountDesc]
    
    func getAmount(amount: Double, index: Int) -> Double {
        if self.type == 0 {
            return amount / Double(amountDesc.count)
        } else if self.type == 1 {
            if let value = amountDesc[index].value {
                return amount * value / 100
            } else {
                return 0
            }
        } else {
            if let value = amountDesc[index].value {
                return value
            } else {
                return 0
            }
        }
    }
    
    func getPayer() -> String? {
        for aAmountDesc in amountDesc where aAmountDesc.value != nil {
            return aAmountDesc.member.id
        }
        return nil
    }
}

struct AmountDesc: Codable {
    let member: MemberInfo
    var value: Double?
}
