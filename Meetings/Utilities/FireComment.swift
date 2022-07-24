//
//  FireComment.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase

class FireComment {
    
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
                    let comment = Comment(document: document)
                    comments.append(comment)
                }
                
                // Return
                completion?(comments)
        }
    }
    
    static func readComments(userId: String, completion: (([Comment]) -> Void)?) {
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
                    let comment = Comment(document: document)
                    comments.append(comment)
                }
                
                // Return
                completion?(comments)
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
