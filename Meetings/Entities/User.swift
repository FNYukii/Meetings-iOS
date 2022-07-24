//
//  User.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase

struct User: Identifiable {
    let id: String
    let displayName: String
    let userTag: String
    let introduction: String
    let iconUrl: String?
    
    init(document: DocumentSnapshot) {
        self.id = document.documentID
        self.displayName = document.get("displayName") as! String
        self.userTag = document.get("userTag") as! String
        self.introduction = document.get("introduction") as! String
        self.iconUrl = document.get("iconPath") as? String
    }
}
