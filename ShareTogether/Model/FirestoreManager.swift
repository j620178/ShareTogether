//
//  FirestoreManager.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/13.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

extension GeoPoint: GeoPointType {}
extension Timestamp: TimestampType {}

struct Collection {
    static let user = "user"
    static let group = "group"
    
    struct User {
        static let groups = "groups"
    }
    
    struct Group {
        static let expense = "expense"
    }
}

struct UserInfo: Codable {
    var id: String!
    let name: String
    let email: String
    let phone: String
    let photoURL: String
    var groups: [UserGroup]!
}

struct UserGroup: Codable {
    var id: String!
    let name: String
    let status: String
}

struct GroupInfo: Codable {
    var id: String!
    let name: String
    let member: String
    var expenses: [Expense]!
}

struct Expense: Codable {
    var id: String?
    let type: Int
    let title: String
    let desc: String
    let userID: String
    let amount: Double
    let payer: [Payer]
    let splitUser: [String]
    let position: GeoPoint
    let time: Timestamp
    
    init(type: Int, title: String, desc: String, userID: String, amount: Double , payer: [Payer], splitUser: [String], lat: Double, lon: Double, time: Date) {
        self.type = type
        self.title = title
        self.desc = desc
        self.userID = userID
        self.amount = amount
        self.payer = payer
        self.splitUser = splitUser
        self.position = GeoPoint(latitude: lat, longitude: lon)
        self.time = Timestamp(date: time)
    }
}

struct Payer: Codable {
    var userID: String
    let value: Int
}

class FirestoreManager {
    
    static let shared = FirestoreManager()
    
    var firestore = Firestore.firestore()
    
    func getUserInfo(uid: String? = AuthManager.shared.uid,
                     completion: @escaping (Result<UserInfo, Error>) -> Void) {
        
        guard let uid = uid else { return }
        
        firestore.collection(Collection.user).document(uid).getDocument { (querySnapshot, error) in
            
            if let document = querySnapshot {
                do {
                    var userInfo = try FirestoreDecoder().decode(UserInfo.self, from: document.data()!)
                    userInfo.id = document.documentID
                    
                    self.getUserGroups(completion: { userGroups in
                        userInfo.groups = userGroups
                        completion(Result.success(userInfo))
                    })
                
                } catch {
                    completion(Result.failure(error))
                }
                
            }
            
        }
        
    }
    
    func getUserGroups(uid: String? = AuthManager.shared.uid,
                       completion: @escaping ([UserGroup]) -> Void) {
        
        guard let uid = uid else { return }
        
        firestore.collection(Collection.user).document(uid).collection(Collection.User.groups).getDocuments { (querySnapshot, error) in
            
            if let documents = querySnapshot?.documents {
                var userGroups = [UserGroup]()
                for document in documents {
                    do {
                        var userGroup = try FirestoreDecoder().decode(UserGroup.self, from: document.data())
                        userGroup.id = document.documentID
                        userGroups.append(userGroup)
                    } catch {
                        print(error)
                    }
                }
                
                completion(userGroups)

            }
            
        }
        
    }
    
    func getExpenses(groupID: String? = UserInfoManager.shaered.currentGroup?.id,
                    completion: @escaping (Result<[Expense], Error>) -> Void) {
        
        guard let groupID = groupID else { return }
        firestore.collection(Collection.group).document(groupID).collection(Collection.Group.expense).order(by: "time", descending: true).getDocuments { (querySnapshot, error) in
            
            if let documents = querySnapshot?.documents {
                
                var expenses = [Expense]()

                for document in documents {
                    do {
                        var expense = try FirestoreDecoder().decode(Expense.self, from: document.data())
                        expense.id = document.documentID
                        expenses.append(expense)
                    } catch {
                        print(error)
                    }
                }
                
                completion(Result.success(expenses))
                
            }
            
        }
        
    }
    
    func addExpense(groupID: String? = UserInfoManager.shaered.currentGroup?.id,
                    expense: Expense,
                    completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let groupID = groupID, let docData = try? FirestoreEncoder().encode(expense) else { return }
        firestore.collection(Collection.group).document(groupID).collection(Collection.Group.expense).addDocument(data: docData) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
            
        }
        
    }
    
}

extension Timestamp {
    func toFullFormat() -> String {
        let date = self.dateValue()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func toSimpleFormat() -> String {
        let date = self.dateValue()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "M月dd日"
        return formatter.string(from: date)
    }
}
