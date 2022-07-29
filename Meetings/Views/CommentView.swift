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
    
    var body: some View {
        
        List {
            
            VStack(alignment: .leading) {
                
                // Header Row
                HStack(alignment: .top) {
                    // Icon Column
                    CommentUserIconButton(comment: comment, isAbleShowingProfileView: true)
                    
                    // Display name & User tag Column
                    CommentUserNameAndTagStack(comment: comment, stackFamily: .vstack)
                    
                    Spacer()
                    
                    // Menu Column
                    CommentMenu(comment: comment)
                }
                
                // Text Row
                Text(comment.text)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Images Row
                CommentImagesRow(comment: comment)
                
                // Date Row
                Text(EditDate.toString(from: comment.createdAt))
                    .foregroundColor(.secondary)
                
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
    }
}
