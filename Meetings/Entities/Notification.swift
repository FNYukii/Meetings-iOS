//
//  Notification.swift
//  Meetings
//
//  Created by Yu on 2022/09/25.
//

import Firebase

struct Notification: Identifiable {
    let id: String
    let createdAt: Date
    let userId: String
    
    let likedUserId: String?
    let likedCommentId: String?
}
