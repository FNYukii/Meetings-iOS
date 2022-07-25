//
//  CommentsPage.swift
//  Meetings
//
//  Created by Yu on 2022/07/25.
//

import SwiftUI

struct PostedCommentsPage: View {
    
    let comments: [Comment]?
    
    var body: some View {
        List {
            // Progress view
            if comments == nil {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
            
            // CommentRows
            if comments != nil {
                ForEach(comments!) { comment in
                    CommentRow(comment: comment, isDisableShowingProfileView: true, isAbleShowingThreadView: true)
                }
                .listRowSeparator(.hidden)
            }            
        }
        .listStyle(.plain)
    }
}
