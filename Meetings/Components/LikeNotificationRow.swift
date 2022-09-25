//
//  NotificationRow.swift
//  Meetings
//
//  Created by Yu on 2022/09/25.
//

import SwiftUI

struct LikeNotificationRow: View {
    
    // Values
    let notification: Notification
    
    // States
    @State private var likedUser: User? = nil
    @State private var isLoadedLikedUser = false
    
    @State private var likedComment: Comment? = nil
    @State private var isLoadedLikedComment = false
    
    // Navigations
    @State private var isShowCommentView = false
    
    var body: some View {
        
        Button(action: {
            isShowCommentView.toggle()
        }) {
            HStack(alignment: .top) {
                // Header Column
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.title)
                
                // Content Column
                VStack(alignment: .leading) {
                    // User Icon Row
                    UserIconImage(userId: likedUser?.id, iconImageFamily: .small)
                    
                    // Detail Row
                    Text("\(likedUser?.displayName ?? "---")さんがあなたのコメントをいいねしました")
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Comment Row
                    Text(likedComment?.text ?? "---")
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .background(
            Group {
                if likedComment != nil {
                    NavigationLink(destination: CommentView(comment: likedComment!), isActive: $isShowCommentView) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        )
        .onAppear(perform: load)
    }
    
    private func load() {
        if likedUser == nil {
            FireUser.readUser(userId: notification.likedUserId!) { user in
                self.likedUser = user
                self.isLoadedLikedUser = true
            }
        }
        
        if likedComment == nil {
            FireComment.readComment(commentId: notification.likedCommentId!) { comment in
                self.likedComment = comment
                self.isLoadedLikedComment = true
            }
        }
    }
}
