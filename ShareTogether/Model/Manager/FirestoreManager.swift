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
import MapKit

extension GeoPoint: GeoPointType {}
extension Timestamp: TimestampType {}

enum FirestoreError: Error {
    case decodeFailed
    case getPlistFailed
    case insertFailed
    case joinDemoGroupFailed
    case uploadFailed
}

struct Collection {
    static let user = "user"
    static let group = "group"
    
    struct User {
        static let groups = "groups"
        static let activity = "activity"
    }
    
    struct Group {
        static let expense = "expense"
        static let member = "member"
        static let note = "notebook"
    }
    
    struct GroupNotebook {
        static let comment = "comment"
    }
    
}

class FirestoreManager {
    
    static let shared = FirestoreManager()
    
    var firestore = Firestore.firestore()
    
    func addNewUser(userInfo: UserInfo, completion: @escaping (Result<GroupInfo, Error>) -> Void) {
        
        guard let docData = try? FirestoreEncoder().encode(userInfo) else { return }

        firestore.collection(Collection.user).document(userInfo.id).setData(docData) { error in
            
            if error != nil {
                completion(Result.failure(FirestoreError.insertFailed))
                return
            }
                    
        }
        
        FirestoreManager.shared.joinDemoGroup(uid: userInfo.id, completion: { result in
            switch result {
            case .success(var demoGroup):
                demoGroup.status = MemberStatusType.joined.rawValue
                completion(Result.success(demoGroup))
                
            case .failure:
                completion(Result.failure(FirestoreError.joinDemoGroupFailed))
            }
        })
    }
    
    func getUserInfo(uid: String? = CurrentManager.shared.user?.id,
                     completion: @escaping (Result<UserInfo?, Error>) -> Void) {
        
        guard let uid = uid else { return }
                
        firestore.collection(Collection.user).document(uid).getDocument { (querySnapshot, error) in
            
            guard let document = querySnapshot, let data = document.data()
            else {
                completion(Result.success(nil))
                return
            }
            
            do {
                var userInfo = try FirestoreDecoder().decode(UserInfo.self, from: data)
                userInfo.id = document.documentID
                
                self.getUserGroups(uid: uid, completion: { userGroups in
                    userInfo.groups = userGroups
                    completion(Result.success(userInfo))
                })
            
            } catch {
                completion(Result.failure(error))
            }
            
        }
        
    }
    
    func getUserGroups(uid: String? = CurrentManager.shared.user?.id,
                       completion: @escaping ([GroupInfo]) -> Void) {
        
        guard let uid = uid else { return }
        
        firestore.collection(Collection.user).document(uid)
            .collection(Collection.User.groups)
            .addSnapshotListener { (querySnapshot, error) in
            
            if let documents = querySnapshot?.documents {
                var userGroups = [GroupInfo]()
                for document in documents {
                    do {
                        var userGroup = try FirestoreDecoder().decode(GroupInfo.self, from: document.data())
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
    
    func getExpense(groupID: String? = CurrentManager.shared.group?.id,
                    expenseID: String,
                    completion: @escaping (Result<Expense?, Error>) -> Void) {
        
        guard let groupID = groupID else { return }
        
        firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.expense).document(expenseID)
            .getDocument { (documentSnapshot, error) in
                guard let document = documentSnapshot,
                    let docData = document.data(),
                    var expense = try? FirestoreDecoder().decode(Expense.self, from: docData)
                else {
                    completion(Result.success(nil))
                    return
                }
                
                expense.id = document.documentID
                
                completion(Result.success(expense))
                
        }
        
    }
    
    func getExpenses(groupID: String? = CurrentManager.shared.group?.id,
                     completion: @escaping (Result<[Expense], Error>) -> Void) {
        
        guard let groupID = groupID else { return }
        
        firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.expense).order(by: "time", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else { return }
            
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
    
    func getMembers(groupID: String? = CurrentManager.shared.group?.id,
                    completion: @escaping (Result<[MemberInfo], Error>) -> Void) {
        
        guard let groupID = groupID else { return }
        
        firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.member)
            .addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else { return }
            
            var members = [MemberInfo]()
            
            for document in documents {
                do {
                    var member = try FirestoreDecoder().decode(MemberInfo.self, from: document.data())
                    member.id = document.documentID
                    members.append(member)
                } catch {
                    print(error)
                }
            }
            
            completion(Result.success(members))
            
        }
        
        completion(Result.success([MemberInfo]()))
    }
    
    func addExpense(groupID: String? = CurrentManager.shared.group?.id,
                    expense: Expense,
                    completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let groupID = groupID,
            let docData = try? FirestoreEncoder().encode(expense) else { return }
        
        firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.expense)
            .addDocument(data: docData) { (error) in
            if let error = error {
                completion(Result.failure(error))
            } else {
                completion(Result.success("success"))
            }
            
        }
    }
    
    func upadteExpense(groupID: String? = CurrentManager.shared.group?.id,
                       expense: Expense,
                       completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let groupID = groupID,
            let docData = try? FirestoreEncoder().encode(expense) else { return }
        
        firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.expense).document(expense.id)
            .setData(docData) { (error) in
            if let error = error {
                completion(Result.failure(error))
            } else {
                completion(Result.success("success"))
            }
            
        }
    }
    
    func searchUser(email: String?,
                    phone: String?,
                    completion: @escaping (Result<UserInfo?, Error>) -> Void) {
        
        if email != nil {
            
            firestore.collection(Collection.user).whereField("email", isEqualTo: email!)
                .getDocuments { (querySnapshot, error) in

                if error != nil {
                    return
                }
                
                guard let documents = querySnapshot?.documents,
                    let document = documents.first,
                    var userInfo = try? FirebaseDecoder().decode(UserInfo.self, from: document.data())
                else {
                    completion(Result.success(nil))
                    return
                }

                userInfo.id = document.documentID
                    
                completion(Result.success(userInfo))
            }
            
        } else if phone != nil {
            
        }
        
    }
    
    func addGroup(groupInfo: GroupInfo, members: [MemberInfo], completion: @escaping (Result<String, Error>) -> Void) {
        
        var reference: DocumentReference?
        
        guard let docData = try? FirestoreEncoder().encode(groupInfo) else { return }
        
        reference = firestore.collection(Collection.group).addDocument(data: docData) { [weak self] error in
            if error != nil {
                print(error)
            }
            
            guard let groupID = reference?.documentID else { return }
            
            let group = GroupInfo(id: groupID, name: groupInfo.name, coverURL: groupInfo.coverURL, status: 3)
            
            for member in members {
                var newMember = member
                if newMember.status == MemberStatusType.willInvite.rawValue {
                    newMember.status = MemberStatusType.inviting.rawValue
                }
                
                self?.addMember(group: group,
                                memberInfo: newMember,
                                isBuilder: newMember.status == MemberStatusType.builder.rawValue)
            }
            
            self?.joinGroup(group: group, completion: { _ in
                completion(Result.success(groupID))
            })
            
        }
        
    }

    func addMember(group: GroupInfo? = CurrentManager.shared.group,
                   memberInfo: MemberInfo,
                   isBuilder: Bool = false) {
        
        guard let group = group,
            let docData = try? FirestoreEncoder().encode(memberInfo),
            let currentUserInfo = CurrentManager.shared.user
        else { return }
        
        firestore.collection(Collection.group).document(group.id)
            .collection(Collection.Group.member).document(memberInfo.id).setData(docData)
            
        if !isBuilder {
            addActivity(type: ActivityType.invite.rawValue,
                        targetMember: memberInfo,
                        pushUser: currentUserInfo,
                        groupInfo: group,
                        amount: nil)
        }

    }
    
    func updateGroupMemberStatus(groupID: String? = CurrentManager.shared.group?.id,
                                 memberInfo: MemberInfo,
                                 status: MemberStatusType,
                                 completion: ((Result<Int, Error>) -> Void)?) {
        
        let data = ["status": status.rawValue]
        
        guard let groupID = groupID else { return }
        
        firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.member).document(memberInfo.id).updateData(data) { error in
            
            if error != nil {
                print("Error updating document: \(error!)")
            }
            
            print("Document successfully updated")
        }
        
    }
    
    func updateUserGroupStatus(uid: String,
                               groupID: String? = CurrentManager.shared.group?.id,
                               status: MemberStatusType,
                               completion: @escaping (Result<Int, Error>) -> Void) {
        
        guard let groupID = groupID else { return }
        
        let data = ["status": status.rawValue]
        
        firestore.collection(Collection.user).document(uid)
            .collection(Collection.User.groups).document(groupID).updateData(data)

    }
    
    func joinGroup(uid: String? = CurrentManager.shared.user?.id,
                   group: GroupInfo,
                   completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let uid = uid,
            let groupID = group.id,
            let docData = try? FirestoreEncoder().encode(group)
            else { return }
        
        firestore.collection(Collection.user).document(uid)
            .collection(Collection.User.groups).document(groupID)
            .setData(docData) { error in
            
            if error != nil {
                completion(Result.failure(FirestoreError.insertFailed))
                return
            }
        }
        
        completion(Result.success(groupID))
    }
    
    func joinDemoGroup(uid: String, completion: @escaping (Result<GroupInfo, Error>) -> Void) {
        
        guard let demoGroupID = Bundle.main.object(forInfoDictionaryKey: "DemoGroupID") as? String,
            let demoGroupCoverURL = Bundle.main.object(forInfoDictionaryKey: "DemoGroupCoverURL") as? String
        else {
            completion(Result.failure(FirestoreError.getPlistFailed))
            return
        }
        
        let demoGroup = GroupInfo(id: demoGroupID,
                                  name: "台北自由行(範例)",
                                  coverURL: demoGroupCoverURL,
                                  status: MemberStatusType.joined.rawValue)

        guard let docData = try? FirestoreEncoder().encode(demoGroup) else { return }
    
        firestore.collection(Collection.user).document(uid)
            .collection(Collection.User.groups).document(demoGroupID).setData(docData) { error in
             
            if error != nil {
                completion(Result.failure(FirestoreError.insertFailed))
                return
            }

            completion(Result.success(demoGroup))
        }
    }
    
    func addActivity(type: Int,
                     targetMember: MemberInfo,
                     pushUser: UserInfo? = CurrentManager.shared.user,
                     groupInfo: GroupInfo? = CurrentManager.shared.group,
                     amount: Double?) {
        
        guard let pushUser = pushUser,
            let groupInfo = groupInfo else { return }
        
        let activity = Activity(type: type,
                                targetMember: targetMember,
                                pushUser: pushUser,
                                groupInfo: groupInfo,
                                amount: amount,
                                time: Date(),
                                status: 0)
        
        guard let docData = try? FirestoreEncoder().encode(activity) else { return }
        
        firestore.collection(Collection.user).document(targetMember.id)
            .collection(Collection.User.activity).addDocument(data: docData)
        
        let pushNotificationProvider = PushNotificationProvider()
        
        for member in CurrentManager.shared.availableMembersWithoutSelf {
            
            guard let fcmToken = member.fcmToken else { return }
            
            FirestoreManager.shared.getActivityBadge(uid: member.id) { [weak self] result in
                
                switch result {
                    
                case .success(let count):
                    
                    if ActivityType(rawValue: activity.type) == ActivityType.addExpense {
                        pushNotificationProvider.send(to: fcmToken,
                                                      title: "新增消費",
                                                      body: "\(pushUser.name) 於 \(groupInfo.name) 新增一筆消費",
                                                      badge: count,
                                                      completion: nil)
                    } else if ActivityType(rawValue: activity.type) == ActivityType.invite {
                        pushNotificationProvider.send(to: fcmToken,
                                                      title: "交友邀請",
                                                      body: "\(pushUser.name) 邀請您加入 \(groupInfo.name)",
                                                      badge: count,
                                                      completion: nil)
                    }
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
            }

        }
        
    }
    
    func getActivity(uid: String, completion: @escaping (Result<[Activity], Error>) -> Void) {
        
        firestore.collection(Collection.user).document(uid)
            .collection(Collection.User.activity).order(by: "time", descending: true)
            .getDocuments { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else { return }
            
            var activities = [Activity]()
            
            for document in documents {
                do {
                    var activity = try FirestoreDecoder().decode(Activity.self, from: document.data())
                    activity.id = document.documentID
                    activities.append(activity)
                } catch {
                    completion(Result.failure(FirestoreError.decodeFailed))
                }
            }
            completion(Result.success(activities))
        }
        
    }
    
    func getActivityBadge(uid: String? = CurrentManager.shared.user?.id,
                          completion: @escaping (Result<Int, Error>) -> Void) {
    
        guard let uid = uid else { return }
        
        firestore.collection(Collection.user).document(uid)
            .collection(Collection.User.activity).whereField("status", isEqualTo: 0)
            .getDocuments { (querySnapshot, error) in
                 
                if let error = error {
                    completion(Result.failure(error))
                    return
                }
            
                guard let documents = querySnapshot?.documents else { return }
                
                completion(Result.success(documents.count))
            
        }
        
    }
    
    func updateActivityType(uid: String? = CurrentManager.shared.user?.id, id: String, type: ActivityType) {
        
        guard let uid = uid else { return }
        
        let data = ["type": type.rawValue]
        firestore.collection(Collection.user).document(uid)
            .collection(Collection.User.activity).document(id).updateData(data)
    }
    
    func updateActivityStatus(uid: String? = CurrentManager.shared.user?.id, id: String, status: ActivityStatus) {
        
        guard let uid = uid else { return }
        
        let data = ["status": status.rawValue]
        firestore.collection(Collection.user).document(uid)
            .collection(Collection.User.activity).document(id).updateData(data)
    }
    
    func getNotes(groupID: String? = CurrentManager.shared.group?.id,
                  completion: @escaping (Result<[Note], Error>) -> Void) {
        
        guard let groupID = groupID else { return }
        
        firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.note).order(by: "time", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                
            guard let documents = querySnapshot?.documents else { return }

            var notes = [Note]()

            for document in documents {
                do {
                    var note = try FirestoreDecoder().decode(Note.self, from: document.data())
                    note.id = document.documentID
                    notes.append(note)

                } catch {
                    completion(Result.failure(FirestoreError.decodeFailed))
                }
            }
                
            for index in notes.indices {

                self.getNoteComment(noteID: notes[index].id) { result in
                    switch result {

                    case .success(let noteComments):
                        notes[index].comments = noteComments
                        if index == (notes.count - 1) {
                            completion(Result.success(notes))
                            return
                        }
                    case .failure:
                        completion(Result.failure(FirestoreError.decodeFailed))
                    }
                }
            }
                
            completion(Result.success(notes))
                
        }
        
    }
    
    func getNoteComment(groupID: String? = CurrentManager.shared.group?.id,
                        noteID: String,
                        completion: @escaping (Result<[NoteComment], Error>) -> Void) {
        
        guard let groupID = groupID else { return }
        
        firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.note)
            .document(noteID)
            .collection(Collection.GroupNotebook.comment)
            .order(by: "time", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                
            guard let documents = querySnapshot?.documents else { return }
            
            var noteComments = [NoteComment]()
            
            for document in documents {
                do {
                    var noteComment = try FirestoreDecoder().decode(NoteComment.self, from: document.data())
                    noteComment.id = document.documentID
                    noteComments.append(noteComment)
                } catch {
                    completion(Result.failure(FirestoreError.decodeFailed))
                }
            }
            completion(Result.success(noteComments))
        }
            
     }
    
    func addNote(groupID: String? = CurrentManager.shared.group?.id,
                 note: Note,
                 completion: @escaping (Result<String, Error>) -> Void) {
        
        var reference: DocumentReference?
        
        guard let groupID = groupID,
            let docData = try? FirestoreEncoder().encode(note) else { return }
        
        reference = firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.note).addDocument(data: docData) { error in
                
                if error != nil {
                    completion(Result.failure(FirestoreError.uploadFailed))
                }
                
                completion(Result.success(reference!.documentID))
        }
           
    }
    
    func deleteNote(groupID: String? = CurrentManager.shared.group?.id,
                 noteID: String) {
        
        guard let groupID = groupID else { return }
        
        firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.note).document(noteID).delete()
    }
    
    func addNoteComment(groupID: String? = CurrentManager.shared.group?.id,
                        noteID: String,
                        noteComments: NoteComment,
                        completion: @escaping (Result<String, Error>) -> Void) {
        
        var reference: DocumentReference?
        
        guard let groupID = groupID,
            let docData = try? FirestoreEncoder().encode(noteComments) else { return }
        
        reference = firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.note).document(noteID)
            .collection(Collection.GroupNotebook.comment).addDocument(data: docData) { error in
                
            if error != nil {
                completion(Result.failure(FirestoreError.uploadFailed))
            }
            
            completion(Result.success(reference!.documentID))

        }
            
    }
    
    func deleteNoteComment(groupID: String? = CurrentManager.shared.group?.id,
                           noteID: String,
                           noteCommentID: String) {
        
        guard let groupID = groupID else { return }
    
        firestore.collection(Collection.group).document(groupID)
            .collection(Collection.Group.note).document(noteID)
            .collection(Collection.GroupNotebook.comment).document(noteCommentID)
            .delete()

    }
    
    func updateFCMToken(token: String, userInfo: UserInfo? = CurrentManager.shared.user) {
        
        guard let userInfo = userInfo else { return }
        
        firestore.collection(Collection.user).document(userInfo.id).updateData(["fcmToken": token])
        
        for group in userInfo.groups {
            firestore.collection(Collection.group).document(group.id)
                .collection(Collection.Group.member).document(userInfo.id)
                .updateData(["fcmToken": token])
        }
        
    }
    
}
