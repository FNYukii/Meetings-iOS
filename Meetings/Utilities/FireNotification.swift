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
    
    static func createLikeNotification(likedCommentId: String, completion: ((String?) -> Void)?) {
        // 非ログイン状態なら終了
        if FireAuth.uid() == nil {
            completion?(nil)
            return
        }
        
        // Commentを取得
        FireComment.readCommentFromServer(commentId: likedCommentId) { comment in
            // 失敗
            if comment == nil {
                completion?(nil)
                return
            }
            
            // 成功
            // Notificationドキュメント追加
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            ref = db.collection("notifications")
                .addDocument(data: [
                    "createdAt": FieldValue.serverTimestamp(),
                    "userId": comment!.userId,
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
    }
    
    static func deleteNotification(likedCommentId: String, completion: ((String?) -> Void)?) {
        // 非ログイン状態なら終了
        if FireAuth.uid() == nil {
            completion?(nil)
            return
        }
        
        // Notificationドキュメントを取得
        let db = Firestore.firestore()
        db.collection("notifications")
            .whereField("likedUserId", isEqualTo: FireAuth.uid()!)
            .whereField("likedCommentId", isEqualTo: likedCommentId)
            .limit(to: 1)
            .getDocuments(source: .server) { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding 1 Notification from server. \(err)")
                    completion?(nil)
                    return
                }
                
                // 結果なし
                if querySnapshot!.documents.count == 0 {
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read 1 Notification from server.")
                let notificationId = querySnapshot!.documents.first!.documentID
                
                // Notificationドキュメントを削除
                db.collection("notifications")
                    .document(notificationId)
                    .delete() { err in
                        // 失敗
                        if let err = err {
                            print("HELLO! Fail! Error removing Notification. \(err)")
                            completion?(nil)
                            return
                        }
                        
                        // 成功
                        print("HELLO! Success! Deleted 1 Notification.")
                        completion?(notificationId)
                    }
            }
    }
}
