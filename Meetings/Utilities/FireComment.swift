//
//  FireComment.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase

class FireComment {
    
    static func toComment(document: QueryDocumentSnapshot) -> Comment {
        let id = document.documentID
        let createdAt = (document.get("createdAt", serverTimestampBehavior: .estimate) as! Timestamp).dateValue()
        let userId = document.get("userId") as! String
        let threadId = document.get("threadId") as! String
        let text = document.get("text") as! String
        
        let comment = Comment(id: id, createdAt: createdAt, userId: userId, threadId: threadId, text: text)
        return comment
    }
    
    static func toComment(document: DocumentSnapshot) -> Comment {
        let id = document.documentID
        let createdAt = (document.get("createdAt", serverTimestampBehavior: .estimate) as! Timestamp).dateValue()
        let userId = document.get("userId") as! String
        let threadId = document.get("threadId") as! String
        let text = document.get("text") as! String
        
        let comment = Comment(id: id, createdAt: createdAt, userId: userId, threadId: threadId, text: text)
        return comment
    }
    
    static func readComment(commentId: String, completion: ((Comment?) -> Void)?) {
        let db = Firestore.firestore()
        db.collection("comments")
            .document(commentId)
            .getDocument { (document, error) in
                // エラー処理
                if let error = error {
                    print("HELLO! Fail! Error reading User. \(error)")
                    completion?(nil)
                    return
                }
                if !document!.exists {
                    print("HELLO! Fail! User not found.")
                    completion?(nil)
                    return
                }
                print("HELLO! Success! Read 1 User.")
                
                // Return
                let comment = toComment(document: document!)
                completion?(comment)
            }
    }
    
    static func readComments(threadId: String, completion: (([Comment]) -> Void)?) {
        // ドキュメント読み取り
        let db = Firestore.firestore()
        db.collection("comments")
            .whereField("threadId", isEqualTo: threadId)
            .order(by: "createdAt", descending: false)
            .limit(to: 3)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("HELLO! Fail! Error Reeding Comments: \(err)")
                    return
                }
                print("HELLO! Success! Read \(querySnapshot!.count) Comments.")
                
                // Comments
                var comments: [Comment] = []
                for document in querySnapshot!.documents {
                    let comment = toComment(document: document)
                    comments.append(comment)
                }
                
                // Return
                completion?(comments)
        }
    }
    
    static func readPostedComments(userId: String, completion: (([Comment]) -> Void)?) {
        // ドキュメント読み取り
        let db = Firestore.firestore()
        db.collection("comments")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: false)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("HELLO! Fail! Error Reeding Comments: \(err)")
                    return
                }
                print("HELLO! Success! Read \(querySnapshot!.count) Comments.")
                
                // Comments
                var comments: [Comment] = []
                for document in querySnapshot!.documents {
                    let comment = toComment(document: document)
                    comments.append(comment)
                }
                
                // Return
                completion?(comments)
            }
    }
    
    static func readLikedComments(userId: String, completion: (([Comment]) -> Void)?) {
        // Userドキュメントを読み取り
        FireUser.readUser(userId: userId) { user in
            // userがnilなら終了
            if user == nil {
                return
            }
            
            // likedCommentIdsの値を取得
            let likedCommentIds = user!.likedCommentIds
            
            // likedCommentIdsが空ならReturnして終了
            if likedCommentIds.count == 0 {
                completion?([])
                return
            }
            
            // ユーザーがいいねしたコメントを全て取得
            let db = Firestore.firestore()
            db.collection("comments")
                .whereField(FieldPath.documentID(), in: likedCommentIds)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("HELLO! Fail! Error Reeding Comments: \(err)")
                        return
                    }
                    print("HELLO! Success! Read \(querySnapshot!.count) Comments.")
                    
                    // Comments
                    var comments: [Comment] = []
                    for document in querySnapshot!.documents {
                        let comment = toComment(document: document)
                        comments.append(comment)
                    }
                    
                    // Return
                    completion?(comments)
                }
        }
    }
    
    static func createComment(threadId: String, text: String) {
        // UIDの有無を確認
        if FireAuth.uid() == nil {
            return
        }
        
        // ドキュメント追加
        let db = Firestore.firestore()
        db.collection("comments")
            .addDocument(data: [
                "createdAt": FieldValue.serverTimestamp(),
                "threadId": threadId,
                "userId": FireAuth.uid()!,
                "text": text,
            ]) { error in
                if let error = error {
                    print("HELLO! Fail! Error adding new document. Error: \(error)")
                } else {
                    print("HELLO! Success! Added 1 Comment.")
                }
            }
    }
    
    static func deleteComment(commentId: String) {
        // ドキュメント削除
        let db = Firestore.firestore()
        db.collection("comments")
            .document(commentId)
            .delete() { err in
            if let err = err {
                print("HELLO! Fail! Error removing document: \(err)")
            } else {
                print("HELLO! Success! Deleted 1 Comment.")
            }
        }
    }
    
}
