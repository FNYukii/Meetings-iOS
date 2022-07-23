//
//  Comment.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase
import Foundation

struct Comment: Identifiable {
    let id: String
    let createdAt: Date
    let userId: String
    let threadId: String
    let text: String
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        self.createdAt = (document.get("createdAt", serverTimestampBehavior: .estimate) as! Timestamp).dateValue()
        self.userId = document.get("userId") as! String
        self.threadId = document.get("threadId") as! String
        self.text = document.get("text") as! String
    }
}
