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
        let iconUrl = document.get("iconPath") as? String
        let likes = document.get("likes") as! [String]
        
        let user = User(id: id, displayName: displayName, userTag: userTag, introduction: introduction, iconUrl: iconUrl, likes: likes)
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
    
    static func readLikedUsers(commentId: String, completion: (([User]) -> Void)?) {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("likes", arrayContains: commentId)
            .getDocuments() { (querySnapshot, err) in
                // エラー処理
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion?([])
                    return
                }
                print("HELLO! Success! Read \(querySnapshot!.count) Users.")
                
                // Users
                var users: [User] = []
                for document in querySnapshot!.documents {
                    let user = toUser(document: document)
                    users.append(user)
                }
                
                // Return
                completion?(users)
            }
    }
    
    static func createUser(userId: String, displayName: String, userTag: String, introduction: String, iconPath: String?) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .setData([
                "displayName": displayName,
                "userTag": userTag,
                "introduction": introduction,
                "iconPath": iconPath as Any,
                "likes": []
            ]) { err in
                if let err = err {
                    print("HELLO! Fail! Error writing User: \(err)")
                } else {
                    print("HELLO! Success! Created 1 User.")
                }
            }
    }
    
}
