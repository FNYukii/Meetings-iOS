//
//  Thread.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import Firebase

struct Thread: Identifiable {
    let id: String
    let createdAt: Date
    let userId: String
    let title: String
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        self.createdAt = (document.get("createdAt", serverTimestampBehavior: .estimate) as! Timestamp).dateValue()
        self.userId = document.get("userId") as! String
        self.title = document.get("title") as! String
    }
}
