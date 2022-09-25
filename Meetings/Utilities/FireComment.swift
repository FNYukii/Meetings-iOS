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
        let createdAt = (document.get("createdAt", serverTimestampBehavior: .estimate) as? Timestamp ?? Timestamp()).dateValue()
        let userId = document.get("userId") as? String ?? ""
        let threadId = document.get("threadId") as? String ?? ""
        let text = document.get("text") as? String ?? ""
        let imageUrls = document.get("imageUrls") as? [String] ?? []
        
        let comment = Comment(id: id, createdAt: createdAt, userId: userId, threadId: threadId, text: text, imageUrls: imageUrls)
        return comment
    }
    
    static func toComment(document: DocumentSnapshot) -> Comment {
        let id = document.documentID
        let createdAt = (document.get("createdAt", serverTimestampBehavior: .estimate) as? Timestamp ?? Timestamp()).dateValue()
        let userId = document.get("userId") as? String ?? ""
        let threadId = document.get("threadId") as? String ?? ""
        let text = document.get("text") as? String ?? ""
        let imageUrls = document.get("imageUrls") as? [String] ?? []
        
        let comment = Comment(id: id, createdAt: createdAt, userId: userId, threadId: threadId, text: text, imageUrls: imageUrls)
        return comment
    }
    
    static func readComment(commentId: String, completion: ((Comment?) -> Void)?) {
        // キャッシュから読み取り
        let db = Firestore.firestore()
        db.collection("comments")
            .document(commentId)
            .getDocument(source: .cache) { (document, error) in
                // 失敗
                if let error = error {
                    print("HELLO! Fail! Error reading Comment from cashe. \(error)")
                    completion?(nil)
                    return
                }
                
                // ドキュメントが無い
                if !document!.exists {
                    print("HELLO! Fail! Comment not found in cashe.")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read 1 Comment from cashe.")
                let comment = toComment(document: document!)
                completion?(comment)
            }
        
        // サーバーから読み取り
        db.collection("comments")
            .document(commentId)
            .getDocument(source: .server) { (document, error) in
                // 失敗
                if let error = error {
                    print("HELLO! Fail! Error reading Comment from cashe. \(error)")
                    completion?(nil)
                    return
                }
                
                // ドキュメントが無い
                if !document!.exists {
                    print("HELLO! Fail! Comment not found in cashe.")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read 1 Comment from cashe.")
                let comment = toComment(document: document!)
                completion?(comment)
            }
    }
    
    // For readLikedComments()
    static func readCommentFromCashe(commentId: String, completion: ((Comment?) -> Void)?) {
        // キャッシュから読み取り
        let db = Firestore.firestore()
        db.collection("comments")
            .document(commentId)
            .getDocument(source: .cache) { (document, error) in
                // 失敗
                if let error = error {
                    print("HELLO! Fail! Error reading User from cashe. \(error)")
                    completion?(nil)
                    return
                }
                
                // ドキュメントが無い
                if !document!.exists {
                    print("HELLO! Fail! User not found in cashe.")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read 1 User from cashe.")
                let comment = toComment(document: document!)
                completion?(comment)
            }
    }
    
    // For readLikedComments()
    static func readCommentFromServer(commentId: String, completion: ((Comment?) -> Void)?) {
        // サーバーから読み取り
        let db = Firestore.firestore()
        db.collection("comments")
            .document(commentId)
            .getDocument { (document, error) in
                // 失敗
                if let error = error {
                    print("HELLO! Fail! Error reading User from server. \(error)")
                    completion?(nil)
                    return
                }
                
                // ドキュメントが無い
                if !document!.exists {
                    print("HELLO! Fail! User not found in server.")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read 1 User from server.")
                let comment = toComment(document: document!)
                completion?(comment)
            }
    }
    
    static func readComments(keyword: String, completion: (([Comment]?) -> Void)?) {
        // keywordが空なら終了
        if keyword.isEmpty {
            completion?(nil)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("comments")
            .order(by: "text")
            .start(at: [keyword])
            .end(at: [keyword + "\u{f8ff}"])
            .limit(to: 100)
            .getDocuments { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding Comments. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(querySnapshot!.count) Comments.")
                
                // commentsに値を代入
                var comments: [Comment] = []
                querySnapshot!.documents.forEach { document in
                    let comment = FireComment.toComment(document: document)
                    comments.append(comment)
                }
                
                // Return
                completion?(comments)
            }
    }
    
    static func readFirstComment(threadId: String, completion: ((Comment?) -> Void)?) {
        // キャッシュからドキュメントを読み取り
        let db = Firestore.firestore()
        db.collection("comments")
            .whereField("threadId", isEqualTo: threadId)
            .order(by: "createdAt")
            .limit(to: 1)
            .getDocuments(source: .cache) { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding Comments from cashe. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(querySnapshot!.count) Comments from cashe.")
                
                // コメントが0件ならnilを返す
                if querySnapshot!.documents.count == 0 {
                    completion?(nil)
                    return
                }
                
                // Comment
                let document = querySnapshot!.documents.first!
                let comment = toComment(document: document)
                
                // Return
                completion?(comment)
            }
        
        // サーバーからドキュメント読み取り
        db.collection("comments")
            .whereField("threadId", isEqualTo: threadId)
            .order(by: "createdAt")
            .limit(to: 1)
            .getDocuments(source: .server) { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding Comments from server. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(querySnapshot!.count) Comments from server.")
                
                // コメントが0件ならnilを返す
                if querySnapshot!.documents.count == 0 {
                    completion?(nil)
                    return
                }
                
                // Comment
                let document = querySnapshot!.documents.first!
                let comment = toComment(document: document)
                
                // Return
                completion?(comment)
            }
    }
    
    static func readNumberOfCommentInThread(threadId: String, completion: ((Int?) -> Void)?) {
        // キャッシュから
        let db = Firestore.firestore()
        db.collection("comments")
            .whereField("threadId", isEqualTo: threadId)
            .limit(to: 1000)
            .getDocuments(source: .cache) { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding Comments from cache. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(querySnapshot!.count) Comments from cache.")
                completion?(querySnapshot!.count)
            }
        
        // サーバーから
        db.collection("comments")
            .whereField("threadId", isEqualTo: threadId)
            .limit(to: 1000)
            .getDocuments(source: .server) { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding Comments from server. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(querySnapshot!.count) Comments from server.")
                completion?(querySnapshot!.count)
            }
    }
    
    static func readPostedComments(userId: String, completion: (([Comment]?) -> Void)?) {
        // キャッシュからドキュメント読み取り
        let db = Firestore.firestore()
        db.collection("comments")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .limit(to: 100)
            .getDocuments(source: .cache) { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding Comments from cashe. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(querySnapshot!.count) Comments from cashe.")
                
                // Comments
                var comments: [Comment] = []
                for document in querySnapshot!.documents {
                    let comment = toComment(document: document)
                    comments.append(comment)
                }
                
                // Return
                completion?(comments)
            }
        
        // サーバーからドキュメント読み取り
        db.collection("comments")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .limit(to: 100)
            .getDocuments() { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding Comments from server. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(querySnapshot!.count) Comments from server.")
                
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
    
    // For readLikedComments()
    static func sortedLikedComments(comments: [Comment]) -> [Comment] {
        let sortedComments = comments.sorted(by: {$0.createdAt > $1.createdAt})
        return sortedComments
    }
    
    static func readLikedComments(userId: String, completion: (([Comment]?) -> Void)?) {
        // Userドキュメントを読み取り
        FireUser.readUser(userId: userId) { user in
            // userが読み取れなかったなら終了
            if user == nil {
                completion?(nil)
                return
            }
            
            // likedCommentIdsの値を取得
            let likedCommentIds = user!.likedCommentIds
            
            // likedCommentIdsが0件なら完了
            if likedCommentIds.count == 0 {
                completion?([])
            }
                        
            // likedCommentIdsの数だけ、ドキュメント読み取りを行う
            // キャッシュから読み取り
            var likedComments1: [Comment] = []
            var readCount1 = 0
            likedCommentIds.forEach { commentId in
                readCommentFromCashe(commentId: commentId) { comment in
                    readCount1 += 1
                                        
                    // 成功
                    if comment != nil {
                        likedComments1.append(comment!)
                    }
                    
                    // 読み取ったドキュメントの数がlikedCommentIdsの数に達したら完了
                    if readCount1 == likedCommentIds.count {
                        let sortedLikedComments = sortedLikedComments(comments: likedComments1)
                        completion?(sortedLikedComments)
                    }
                }
            }
            
            // サーバーから読み取り
            var likedComments2: [Comment] = []
            var readCount2 = 0
            likedCommentIds.forEach { commentId in
                readCommentFromServer(commentId: commentId) { comment in
                    readCount2 += 1
                                        
                    // 成功
                    if comment != nil {
                        likedComments2.append(comment!)
                    }
                    
                    // 読み取ったドキュメントの数がlikedCommentIdsの数に達したら完了
                    if readCount2 == likedCommentIds.count {
                        let sortedLikedComments = sortedLikedComments(comments: likedComments2)
                        completion?(sortedLikedComments)
                    }
                }
            }
        }
    }
    
    static func readCommentWithImage(completion: ((Comment?) -> Void)?) {
        // キャッシュから
        let db = Firestore.firestore()
        db.collection("comments")
            .whereField("imageUrls", isNotEqualTo: [])
            .limit(to: 1)
            .getDocuments(source: .cache) { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding 1 Comment from cache. \(err)")
                    completion?(nil)
                    return
                }
                
                // 結果なし
                if querySnapshot!.documents.count == 0 {
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read 1 Comment from cache.")
                
                // Return
                let comment = toComment(document: querySnapshot!.documents.first!)
                completion?(comment)
            }
        
        // サーバーから
        db.collection("comments")
            .whereField("imageUrls", isNotEqualTo: [])
            .limit(to: 1)
            .getDocuments(source: .server) { (querySnapshot, err) in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error Reeding 1 Comment from server. \(err)")
                    completion?(nil)
                    return
                }
                
                // 結果なし
                if querySnapshot!.documents.count == 0 {
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Read 1 Comment from server.")
                
                // Return
                let comment = toComment(document: querySnapshot!.documents.first!)
                completion?(comment)
            }
    }
    
    static func createComment(threadId: String, text: String, imageUrls: [String], completion: ((String?) -> Void)?) {
        // UIDの有無を確認
        if FireAuth.uid() == nil {
            completion?(nil)
            return
        }
        
        // ドキュメント追加
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("comments")
            .addDocument(data: [
                "createdAt": FieldValue.serverTimestamp(),
                "threadId": threadId,
                "userId": FireAuth.uid()!,
                "text": text,
                "imageUrls": imageUrls
            ]) { error in
                // 失敗
                if let error = error {
                    print("HELLO! Fail! Error adding new Comment. \(error)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Added 1 Comment.")
                completion?(ref!.documentID)
                
                // スレッドのcommentedAtを更新
                FireThread.updateThreadCommentedAt(threadId: threadId) { _ in
                    // Do nothing
                }
            }
    }
    
    static func deleteComment(commentId: String, completion: ((String?) -> Void)?) {
        // ドキュメント削除
        let db = Firestore.firestore()
        db.collection("comments")
            .document(commentId)
            .delete() { err in
                // 失敗
                if let err = err {
                    print("HELLO! Fail! Error removing Comment. \(err)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Deleted 1 Comment.")
                completion?(commentId)
            }
    }
    
}
