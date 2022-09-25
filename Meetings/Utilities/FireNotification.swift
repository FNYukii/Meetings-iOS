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
    
    static func createLikeNotification(userId: String, likedUserId: String, likedCommentId: String, completion: ((String?) -> Void)?) {
        // 非ログイン状態なら終了
        if FireAuth.uid() == nil {
            completion?(nil)
            return
        }
        
        // ドキュメント追加
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("notifications")
            .addDocument(data: [
                "createdAt": FieldValue.serverTimestamp(),
                "userId": userId,
                "likedUserId": FireAuth.uid()!,
                "likedCommentId": likedCommentId
            ]) { error in
                // 失敗
                if let error = error {
                    print("HELLO! Fail! Error adding new Notification. \(error)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Added 1 Notification.")
                completion?(ref!.documentID)
            }
    }
    
    static func deleteNotification(userId: String, likedUserId: String, likedCommentId: String, completion: ((String?) -> Void)?) {
        // TODO: notificationsコレクションからドキュメントを削除
    }
}
