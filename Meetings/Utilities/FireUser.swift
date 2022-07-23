//
//  FireUser.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase

class FireUser {
    
//    static func readUser(userId: String, completion: (()))
    
    static func createUser(userId: String, displayName: String, userTag: String, iconPath: String?) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .setData([
                "displayName": displayName,
                "userTag": userTag,
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
