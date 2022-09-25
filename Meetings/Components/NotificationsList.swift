//
//  NotificationsList.swift
//  Meetings
//
//  Created by Yu on 2022/09/25.
//

import SwiftUI

struct NotificationsList: View {
    
    @ObservedObject private var notificationsViewModel = NotificationsViewModel()
    
    var body: some View {
        List {

            // Progress
            if !notificationsViewModel.isLoaded {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }
            
            // Failed
            if notificationsViewModel.isLoaded && notificationsViewModel.notifications == nil {
                Text("notifications_reading_failed")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // No Results
            if notificationsViewModel.isLoaded && notificationsViewModel.notifications != nil && notificationsViewModel.notifications!.count == 0 {
                Text("no_notifications")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // Done
            if notificationsViewModel.isLoaded && notificationsViewModel.notifications != nil {
                ForEach(notificationsViewModel.notifications!) { notification in
                    if notification.likedUserId != nil && notification.likedCommentId != nil {
                        LikeNotificationRow(notification: notification)
                    }
                }
                .listRowSeparator(.hidden, edges: .top)
                .listRowSeparator(.visible, edges: .bottom)
            }
        }
        .listStyle(.plain)
    }
}
