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
                if let document = document, document.exists {
                    let user = toUser(document: document)
                    print("HELLO! Success! Read 1 User.")
                    completion?(user)
                } else {
                    print("HELLO! Fail! User identified as \(userId) does not exist.")
                    completion?(nil)
                }
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
