//
//  CommentsViewModel.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Foundation
import Firebase
import SwiftUI

class CommentsViewModel: ObservableObject {
    
    @Published var comments: [Comment] = []
    @Published var isLoaded = false
    
    init(threadId: String) {
        
        let db = Firestore.firestore()
        db.collection("comments")
            .whereField("threadId", isEqualTo: threadId)
            .order(by: "createdAt")
            .limit(to: 1000)
            .addSnapshotListener {(snapshot, error) in
                // エラー処理
                guard let snapshot = snapshot else {
                    print("HELLO! Fail! Error fetching snapshots: \(error!)")
                    return
                }
                print("HELLO! Success! Read \(snapshot.documents.count) Comments.")
                
                // Comments
                var comments: [Comment] = []
                snapshot.documents.forEach { document in
                    let comment = FireComment.toComment(document: document)
                    comments.append(comment)
                }
                
                // プロパティに反映
                withAnimation {
                    self.comments = comments
                    self.isLoaded = true
                }
            }
    }
        
}
