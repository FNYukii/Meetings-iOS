//
//  CommentsPage.swift
//  Meetings
//
//  Created by Yu on 2022/07/25.
//

import SwiftUI

struct CommentsPage: View {
    
    let comments: [Comment]?
    
    var body: some View {
        VStack {
            // Progress view
            if comments == nil {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                }
            }
            
            // CommentRows
            if comments != nil {
                ForEach(comments!) { comment in
                    CommentRow(comment: comment, isDisableShowingProfileView: true, isAbleShowingThreadView: true)
                }
            }
            
            Spacer()
        }
    }
}
