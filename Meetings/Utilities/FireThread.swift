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
        // キャッシュから読み取り
        let db = Firestore.firestore()
        db.collection("threads")
            .document(threadId)
            .getDocument(source: .cache) { (document, error) in
                // 失敗
                if let error = error {
                    print("HELLO! Fail! Error reading Thread from cashe. \(error)")
                    completion?(nil)
                    return
                }
                
                // ドキュメントが無い
                if !document!.exists {
                    print("HELLO! Fail! Thread not found in cashe.")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read 1 Thread from cashe.")
                let thread = toThread(document: document!)
                completion?(thread)
            }
        
        // サーバーから読み取り
        db.collection("threads")
            .document(threadId)
            .getDocument { (document, error) in
                // 失敗
                if let error = error {
                    print("HELLO! Fail! Error reading Thread from server. \(error)")
                    completion?(nil)
                    return
                }
                
                // ドキュメントが無い
                if !document!.exists {
                    print("HELLO! Fail! Thread not found in server.")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read 1 Thread from cashe.")
                let thread = toThread(document: document!)
                completion?(thread)
            }
    }
    
    static func createThread(title: String, completion: ((String?) -> Void)?) {
        // UIDの有無を確認
        if FireAuth.uid() == nil {
            completion?(nil)
            return
        }
        
        // ドキュメントを追加
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("threads")
            .addDocument(data: [
                "createdAt": FieldValue.serverTimestamp(),
                "userId": FireAuth.uid()!,
                "title": title
            ]) { error in
                // 失敗
                if let error = error {
                    print("HELLO! Fail! Error adding new Thread. \(error)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Added 1 Thread.")
                completion?(ref!.documentID)
            }
    }
    
    static func deleteThread(threadId: String) {
        // ドキュメント削除
        let db = Firestore.firestore()
        db.collection("threads")
            .document(threadId)
            .delete() { err in
                if let err = err {
                    print("HELLO! Fail! Error removing Thread. \(err)")
                } else {
                    print("HELLO! Success! Deleted 1 Thread.")
                }
            }
    }
    
}
