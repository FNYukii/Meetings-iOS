//
//  FireThread.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase

class FireThread {
    
    static func toThread(document: DocumentSnapshot) -> Thread {
        let id = document.documentID
        let createdAt = (document.get("createdAt", serverTimestampBehavior: .estimate) as! Timestamp).dateValue()
        let userId = document.get("userId") as! String
        let title = document.get("title") as! String
        
        let thread = Thread(id: id, createdAt: createdAt, userId: userId, title: title)
        return thread
    }
    
    static func toThread(document: QueryDocumentSnapshot) -> Thread {
        let id = document.documentID
        let createdAt = (document.get("createdAt", serverTimestampBehavior: .estimate) as! Timestamp).dateValue()
        let userId = document.get("userId") as! String
        let title = document.get("title") as! String
        
        let thread = Thread(id: id, createdAt: createdAt, userId: userId, title: title)
        return thread
    }
    
    static func readThread(threadId: String, completion: ((Thread?) -> Void)?) {
        let db = Firestore.firestore()
        db.collection("threads")
            .document(threadId)
            .getDocument { (document, error) in
                // エラー処理
                if let error = error {
                    print("HELLO! Fail! Error reading Thread. \(error)")
                    completion?(nil)
                    return
                }
                if !document!.exists {
                    print("HELLO! Fail! Thread not found.")
                    completion?(nil)
                    return
                }
                print("HELLO! Success! Read 1 Thread.")
                
                // Return
                let thread = toThread(document: document!)
                completion?(thread)
            }
    }
    
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
        // ドキュメント削除
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
