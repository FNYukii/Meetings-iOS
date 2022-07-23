//
//  FireComment.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase

class FireComment {
    
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
