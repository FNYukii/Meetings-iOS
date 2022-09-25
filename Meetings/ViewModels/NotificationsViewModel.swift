//
//  NotificationsViewModel.swift
//  Meetings
//
//  Created by Yu on 2022/09/25.
//

import Firebase
import SwiftUI

class NotificationsViewModel: ObservableObject {
    
    @Published var notifications: [Notification]? = []
    @Published var isLoaded = false
    
    init() {
        // 非ログイン状態なら終了
        if FireAuth.uid() == nil {
            self.notifications = nil
            self.isLoaded = true
            return
        }
        
        let db = Firestore.firestore()
        db.collection("notifications")
            .whereField("userId", isEqualTo: FireAuth.uid()!)
            .order(by: "createdAt", descending: true)
            .limit(to: 50)
            .addSnapshotListener {(snapshot, error) in
                // 失敗
                guard let snapshot = snapshot else {
                    print("HELLO! Fail! Error fetching snapshots: \(error!)")
                    self.notifications = nil
                    self.isLoaded = true
                    return
                }
                
                // 成功
                print("HELLO! Success! Read \(snapshot.documents.count) Notifications.")
                var notifications: [Notification] = []
                snapshot.documents.forEach { document in
                    let notification = FireNotification.toNotification(document: document)
                    notifications.append(notification)
                }
                
                // プロパティに反映
                withAnimation {
                    self.notifications = notifications
                    self.isLoaded = true
                }
            }
    }
}
