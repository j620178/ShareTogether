//
//  Firestore.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/26.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MapKit

enum ActivityType: Int {
    case addMember = 0
    case addExpense = 1
}

struct UserInfo: Codable {
    var id: String!
    let name: String
    let email: String
    let phone: String?
    let photoURL: String
    var groups: [GroupInfo]!
}

struct UploadUserInfo: Codable {
    let name: String
    let email: String
    let phone: String?
    let photoURL: String
}

struct GroupInfo: Codable {
    var id: String!
    let name: String
    let coverURL: String
    var status: Int?
}

struct MemberInfo: Codable {
    var id: String!
    let name: String
    let email: String
    let photoURL: String
    var status: Int
    
    init(userInfo: UserInfo, status: Int) {
        self.id = userInfo.id
        self.name = userInfo.name
        self.email = userInfo.email
        self.photoURL = userInfo.photoURL
        self.status = status
    }
}

struct Expense: Codable {
    var id: String?
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

struct Activity: Codable {
    var id: String!
    let type: Int
    let status: Int
    let targetMember: MemberInfo
    let pushUser: UserInfo
    let groupInfo: GroupInfo?
    let amount: Double?
    let time: Timestamp
    
    init(type: Int,
         targetMember: MemberInfo,
         pushUser: UserInfo,
         groupInfo: GroupInfo?,
         amount: Double?,
         time: Date,
         status: Int) {
        
        self.type = type
        self.targetMember = targetMember
        self.pushUser = pushUser
        self.groupInfo = groupInfo
        self.amount = amount
        self.time = Timestamp(date: time)
        self.status = status
    }
}

enum ActivityStatus: Int {
    case new = 0
    case readed = 1
    case used = 2
}

struct Note: Codable {
    var id: String!
    let content: String
    let auctorID: String
    var comments: [NoteComment]?
    let time: Timestamp
    
    init(id: String?,
         content: String,
         auctorID: String,
         comments: [NoteComment]?,
         time: Date) {
        
        self.id = id
        self.content = content
        self.auctorID = auctorID
        self.comments = comments
        self.time = Timestamp(date: time)
    }
}

struct NoteComment: Codable {
    var id: String?
    let auctorID: String
    let content: String?
    let mediaID: String?
    let time: Timestamp
    
    init(id: String?,
         auctorID: String,
         content: String?,
         mediaID: String?,
         time: Date) {
        
        self.id = id
        self.auctorID = auctorID
        self.content = content
        self.mediaID = mediaID
        self.time = Timestamp(date: time)
    }
}
