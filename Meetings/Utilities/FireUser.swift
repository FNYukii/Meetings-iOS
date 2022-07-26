//
//  FireUser.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase

class FireUser {
    
    static func toUser(document: DocumentSnapshot) -> User {
        let id = document.documentID
        let displayName = document.get("displayName") as! String
        let userTag = document.get("userTag") as! String
        let introduction = document.get("introduction") as! String
        let iconUrl = document.get("iconUrl") as? String
        let likedCommentIds = document.get("likedCommentIds") as! [String]
        
        let user = User(id: id, displayName: displayName, userTag: userTag, introduction: introduction, iconUrl: iconUrl, likedCommentIds: likedCommentIds)
        return user
    }
    
    static func readUser(userId: String, completion: ((User?) -> Void)?) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .getDocument { (document, error) in
                // エラー処理
                if let error = error {
                    print("HELLO! Fail! Error reading User. \(error)")
                    completion?(nil)
                    return
                }
                if !document!.exists {
                    print("HELLO! Fail! User not found.")
                    completion?(nil)
                    return
                }
                print("HELLO! Success! Read 1 User.")
                
                // Return
                let user = toUser(document: document!)
                completion?(user)
            }
    }
    
    static func readLikedUserIds(commentId: String, completion: (([String]?) -> Void)?) {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("likedCommentIds", arrayContains: commentId)
            .getDocuments() { (querySnapshot, err) in
                // エラー処理
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion?(nil)
                    return
                }
                print("HELLO! Success! Read \(querySnapshot!.count) Users.")
                
                // Users
                var users: [User] = []
                for document in querySnapshot!.documents {
                    let user = toUser(document: document)
                    users.append(user)
                }
                
                // User IDs
                var userIds: [String] = []
                users.forEach { user in
                    let userId = user.id
                    userIds.append(userId)
                }
                
                // Return
                completion?(userIds)
            }
    }
    
    static func createUser(userId: String, displayName: String, userTag: String, introduction: String, iconUrl: String?) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .setData([
                "displayName": displayName,
                "userTag": userTag,
                "introduction": introduction,
                "iconUrl": iconUrl as Any,
                "likedCommentIds": []
            ]) { err in
                if let err = err {
                    print("HELLO! Fail! Error writing User: \(err)")
                } else {
                    print("HELLO! Success! Created 1 User.")
                }
            }
    }
    
    static func likeComment(commentId: String) {
        // UIDを確認
        if FireAuth.uid() == nil {
            return
        }
        
        // Userドキュメントをアップデート
        let db = Firestore.firestore()
        db.collection("users")
            .document(FireAuth.uid()!)
            .updateData([
                "likedCommentIds": FieldValue.arrayUnion([commentId])
            ]) { err in
                if let err = err {
                    print("HELLO! Fail! Error updating User. Error: \(err)")
                } else {
                    print("HELLO! Success! Updated 1 User.")
                }
            }
    }
    
    static func unlikeComment(commentId: String) {
        // UIDを確認
        if FireAuth.uid() == nil {
            return
        }
        
        // Userドキュメントをアップデート
        let db = Firestore.firestore()
        db.collection("users")
            .document(FireAuth.uid()!)
            .updateData([
                "likedCommentIds": FieldValue.arrayRemove([commentId])
            ]) { err in
                if let err = err {
                    print("HELLO! Fail! Error updating User. Error: \(err)")
                } else {
                    print("HELLO! Success! Updated 1 User.")
                }
            }
    }
    
}
