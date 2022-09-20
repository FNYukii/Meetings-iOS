//
//  CommentsPage.swift
//  Meetings
//
//  Created by Yu on 2022/07/25.
//

import SwiftUI

struct CommentsByUserGroup: View {
    
    // User ID, Comments family
    let userId: String
    let commentRowListFamily: CommentRowListFamily
    
    // States
    @State private var comments: [Comment]? = nil
    @State private var isLoadedComments = false
    
    var body: some View {
        Group {
            // Progress view
            if !isLoadedComments {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }
            
            // Reading failed text
            if isLoadedComments && comments == nil {
                Text("comments_reading_failed")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // No content text
            if isLoadedComments && comments?.count == 0 {
                Text("no_comments")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // CommentRows
            if isLoadedComments && comments != nil {
                ForEach(comments!) { comment in
                    CommentRow(comment: comment, isAbleShowingProfileView: userId != comment.userId, isShowThread: true)
                        .listRowSeparator(.hidden, edges: .top)
                        .listRowSeparator(.visible, edges: .bottom)
                }
            }            
        }
        .listStyle(.plain)
        .onAppear(perform: load)
    }
    
    private func load() {
        // postsが指定されたなら、ユーザーが投稿したコメントを読み取り
        if commentRowListFamily == .posts {
            FireComment.readPostedComments(userId: userId) { comments in
                self.comments = comments
                self.isLoadedComments = true
            }
        }
        
        // likesが指定されたなら、ユーザーがいいねしたコメントを読み取り
        if commentRowListFamily == .likes {
            FireComment.readLikedComments(userId: userId) { comment in
                self.comments = comment
                self.isLoadedComments = true
            }
        }
    }
}

enum CommentRowListFamily: Int {
    case posts = 0
    case likes = 1
}
