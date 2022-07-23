//
//  FireThread.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase

class FireThread {
    
    static func createThread(title: String) {
        // UIDの有無を確認
        if FireAuth.uid() == nil {
            return
        }
        
        // ドキュメントを追加
        let db = Firestore.firestore()
        db.collection("threads")
            .addDocument(data: [
                "createdAt": FieldValue.serverTimestamp(),
                "userId": FireAuth.uid()!,
                "title": title
            ]) { error in
                if let error = error {
                    print("HELLO! Fail! Error adding new document. Error: \(error)")
                } else {
                    print("HELLO! Success! Added 1 Thread.")
                }
            }
    }
    
    static func deleteThread(threadId: String) {
        let db = Firestore.firestore()
        db.collection("threads")
            .document(threadId)
            .delete() { err in
            if let err = err {
                print("HELLO! Fail! Error removing document: \(err)")
            } else {
                print("HELLO! Success! Deleted 1 Thread.")
            }
        }
    }
    
}
