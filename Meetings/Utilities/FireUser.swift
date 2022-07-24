//
//  FireUser.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase

class FireUser {
    
    static func readUser(userId: String, completion: ((User?) -> Void)?) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    let user = User(document: document)
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
            ]) { err in
                if let err = err {
                    print("HELLO! Fail! Error writing User: \(err)")
                } else {
                    print("HELLO! Success! Created 1 User.")
                }
            }
    }
    
}
