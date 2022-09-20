//
//  ThreadsByKeywordViewModel.swift
//  Meetings
//
//  Created by Yu on 2022/09/20.
//

import Firebase
import SwiftUI

class ThreadsByKeywordViewModel: ObservableObject {
    
    @Published var threads: [Thread]? = []
    @Published var isLoaded = false
    
    private var listener: ListenerRegistration? = nil
    
    func read(keyword: String) {
        
        isLoaded = false
        
        // 前回のリスナーをデタッチ
        if let listener = listener {
            listener.remove()
        }
        
        // keywordが空なら終了
        if keyword.isEmpty {
            threads = []
            return
        }
        
        let db = Firestore.firestore()
        listener = db.collection("threads")
            .order(by: "title")
            .start(at: [keyword])
            .end(at: [keyword + "\u{f8ff}"])
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
