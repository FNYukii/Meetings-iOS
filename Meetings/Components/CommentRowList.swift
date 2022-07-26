//
//  CommentsPage.swift
//  Meetings
//
//  Created by Yu on 2022/07/25.
//

import SwiftUI

struct CommentRowList: View {
    
    let comments: [Comment]?
    
    var body: some View {
        List {
            // Progress view
            if comments == nil {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }
            
            // No content text
            if comments?.count == 0 {
                Text("no_comments")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // CommentRows
            if comments != nil {
                ForEach(comments!) { comment in
                    CommentRow(comment: comment, isDisableShowingProfileView: true, isAbleShowingThreadView: true)
                }
                .listRowSeparator(.hidden, edges: .top)
                .listRowSeparator(.visible, edges: .bottom)
            }            
        }
        .listStyle(.plain)
    }
}
