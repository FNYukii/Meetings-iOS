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
        let createdAt = (document.get("createdAt", serverTimestampBehavior: .estimate) as? Timestamp ?? Timestamp()).dateValue()
        let userId = document.get("userId") as? String ?? ""
        let title = document.get("title") as? String ?? ""
        let tags = document.get("tags") as? [String] ?? []
        
        let thread = Thread(id: id, createdAt: createdAt, userId: userId, title: title, tags: tags)
        return thread
    }
    
    static func toThread(document: QueryDocumentSnapshot) -> Thread {
        let id = document.documentID
        let createdAt = (document.get("createdAt", serverTimestampBehavior: .estimate) as? Timestamp ?? Timestamp()).dateValue()
        let userId = document.get("userId") as? String ?? ""
        let title = document.get("title") as? String ?? ""
        let tags = document.get("tags") as? [String] ?? []
        
        let thread = Thread(id: id, createdAt: createdAt, userId: userId, title: title, tags: tags)
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
    
    static func readThreads(keyword: String, completion: (([Thread]?) -> Void)?) {
        let db = Firestore.firestore()
        
        // タイトルで検索
        db.collection("threads")
            .order(by: "title")
            .start(at: [keyword])
            .end(at: [keyword + "\u{f8ff}"])
            .getDocuments { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding Threads by title. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(querySnapshot!.count) Threads.")
                
                // threadsに値を代入
                var threads: [Thread] = []
                querySnapshot!.documents.forEach { document in
                    let thread = FireThread.toThread(document: document)
                    threads.append(thread)
                }
                
                // 次はタグで検索
                db.collection("threads")
                    .whereField("tags", arrayContains: keyword)
                    .getDocuments { (querySnapshot, err) in
                        // 失敗
                        if let err = err {
                            print("HELLO! Fail! Error Reeding Threads by tag. \(err)")
                            completion?(nil)
                            return
                        }
                        
                        // 成功
                        print("HELLO! Success! Read \(querySnapshot!.count) Threads.")
                        
                        // threadsに値を追加
                        querySnapshot!.documents.forEach { document in
                            let thread = FireThread.toThread(document: document)
                            threads.append(thread)
                        }
                        
                        // threadsから重複したthreadを削除
                        threads = NSOrderedSet(array: threads).array as! [Thread]
                        
                        // Return
                        completion?(threads)
                    }
            }
    }
    
    static func readRecentlyUsedTags(completion: (([String]?) -> Void)?) {
        let db = Firestore.firestore()
        db.collection("threads")
            .order(by: "createdAt", descending: true)
            .limit(to: 50)
            .getDocuments { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding Threads by tag. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(querySnapshot!.count) Threads.")
                
                // threads
                var threads: [Thread] = []
                querySnapshot!.documents.forEach { document in
                    let thread = FireThread.toThread(document: document)
                    threads.append(thread)
                }
                
                // recentlyUsedTags
                var recentlyUsedTags: [String] = []
                threads.forEach { thread in
                    let tags = thread.tags
                    recentlyUsedTags.append(contentsOf: tags)
                }
                
                // recentlyUsedTagsから重複した要素を削除
                recentlyUsedTags = NSOrderedSet(array: recentlyUsedTags).array as! [String]
                
                // Return
                completion?(recentlyUsedTags)
            }
    }
    
    static func readNumberOfThreadByTag(tag: String, completion: ((Int?) -> Void)?) {
        let db = Firestore.firestore()
        db.collection("threads")
            .whereField("tags", arrayContains: tag)
            .getDocuments { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding Threads by tag. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(querySnapshot!.count) Threads.")
                
                // Return
                completion?(querySnapshot!.count)
            }
    }
    
    static func createThread(title: String, tags: [String], completion: ((String?) -> Void)?) {
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
                "title": title,
                "tags": tags
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
    
    static func updateThreadCommentedAt(threadId: String, completion: ((String?) -> Void)?) {
        let db = Firestore.firestore()
        db.collection("threads")
            .document(threadId)
            .updateData([
                "commentedAt": FieldValue.serverTimestamp()
            ]) { err in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error updating 1 Thread. \(err)")
                    completion?(nil)
                }
                
                // 成功
                print("HELLO! Success! Updated 1 Thread.")
                completion?(threadId)
            }
    }
    
    static func deleteThread(threadId: String, completion: ((String?) -> Void)?) {
        // ドキュメント削除
        let db = Firestore.firestore()
        db.collection("threads")
            .document(threadId)
            .delete() { err in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error removing Thread. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Deleted 1 Thread.")
                completion?(threadId)
            }
    }
    
}
