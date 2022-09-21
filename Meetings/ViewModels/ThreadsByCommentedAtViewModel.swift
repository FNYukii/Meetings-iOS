//
//  ThreadsByCommentedAtViewModel.swift
//  Meetings
//
//  Created by Yu on 2022/09/22.
//

import Firebase
import SwiftUI

class ThreadsByCommentedAtViewModel: ObservableObject {
    
    @Published var threads: [Thread]? = []
    @Published var isLoaded = false
    
    init() {
        let db = Firestore.firestore()
        db.collection("threads")
            .order(by: "commentedAt", descending: true)
            .addSnapshotListener {(snapshot, error) in
                // 失敗
                guard let snapshot = snapshot else {
                    print("HELLO! Fail! Error fetching snapshots: \(error!)")
                    self.threads = nil
                    self.isLoaded = true
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(snapshot.documents.count) Threads.")
                var threads: [Thread] = []
                snapshot.documents.forEach { document in
                    let thread = FireThread.toThread(document: document)
                    threads.append(thread)
                }
                
                // プロパティに反映
                withAnimation {
                    self.threads = threads
                    self.isLoaded = true
                }
            }
    }
}
