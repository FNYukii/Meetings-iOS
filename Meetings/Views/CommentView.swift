//
//  CommentView.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI

struct CommentView: View {
    
    // Comment to show
    let comment: Comment
    
    // States
    @State private var isCommentDeleted = false
    
    var body: some View {
        
        List {
            
            VStack(alignment: .leading) {
                
                // Header Row
                HStack(alignment: .top) {
                    // Icon Column
                    UserIconButton(userId: comment.userId)
                    
                    // Display name & User tag Column
                    VStack(alignment: .leading) {
                        UserDisplayNameText(userId: comment.userId)
                        UserUserTagText(userId: comment.userId)
                    }
                }
                
                // Text Row
                Text(comment.text)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Images Row
                CommentImagesRow(comment: comment)
                
                // Date Row
                Text(EditDate.toString(from: comment.createdAt))
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
                
                // Reaction Row
                CommentReactionRow(comment: comment)
                
                // Thread Title Row
                CommentThreadTitleRow(comment: comment)
            }
            .listRowSeparator(.hidden, edges: .top)
            .listRowSeparator(.visible, edges: .bottom)
        }
        .listStyle(.plain)
        
        .navigationTitle("comment")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Menu Column
                CommentMenu(comment: comment, isCommentDeleted: $isCommentDeleted)
            }
        }
    }
}
