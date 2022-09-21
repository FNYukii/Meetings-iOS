//
//  CommentsPage.swift
//  Meetings
//
//  Created by Yu on 2022/07/25.
//

import SwiftUI

struct CommentsPostedByUserGroup: View {
    
    // User ID, Comments family
    let userId: String
    
    // States
    @State private var comments: [Comment]? = nil
    @State private var isLoadedComments = false
    
    var body: some View {
        Group {
            // Progress
            if !isLoadedComments {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }
            
            // Failed
            if isLoadedComments && comments == nil {
                Text("comments_reading_failed")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // No results
            if isLoadedComments && comments?.count == 0 {
                Text("no_comments")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // Done
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
        FireComment.readPostedComments(userId: userId) { comment in
            self.comments = comment
            self.isLoadedComments = true
        }
    }
}
