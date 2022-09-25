//
//  FireNotification.swift
//  Meetings
//
//  Created by Yu on 2022/09/25.
//

import Firebase

class FireNotification {
    
    static func toNotification(document: QueryDocumentSnapshot) -> Notification {
        let id = document.documentID
        let createdAt = (document.get("createdAt", serverTimestampBehavior: .estimate) as? Timestamp ?? Timestamp()).dateValue()
        let userId = document.get("userId") as? String ?? ""
        
        let likedUserId = document.get("likedUserId") as? String
        let likedCommentId = document.get("likedCommentId") as? String
        
        let notification = Notification(id: id, createdAt: createdAt, userId: userId, likedUserId: likedUserId, likedCommentId: likedCommentId)
        return notification
    }
    
    static func createNotification() {
        // TODO: notificationsコレクションに新しいドキュメントを追加
    }
    
    static func deleteNotification(notificationId: String) {
        // TODO: notificationsコレクションからドキュメントを削除
    }
}
