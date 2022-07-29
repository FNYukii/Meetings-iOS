//
//  CommentRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct CommentRow: View {
    
    // Comment to show
    let comment: Comment
    
    // Navigations
    let isAbleShowingProfileView: Bool
    let isAbleShowingThreadView: Bool
    let isAbleShowingCommentView: Bool
    
    @State private var isShowProfileView = false
            
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            
            // Icon Column
            Button (action: {
                isShowProfileView.toggle()
            }) {
                UserIconImage(userId: comment.userId, iconImageFamily: .medium)
            }
            .buttonStyle(.borderless)
            .disabled(!isAbleShowingProfileView)
            
            // Content Column
            VStack(alignment: .leading) {
                // Header Row
                HStack {
                    // Display name & User tag Column
                    CommentUserNameAndTagStack(comment: comment, stackFamily: .hstack)
                    
                    // Date Column
                    EditDate.howManyAgoText(from: comment.createdAt)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Menu Column
                    CommentMenu(comment: comment)
                }
                
                // Text Row
                Text(comment.text)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Images Row
                CommentImagesRow(comment: comment)
                
                // Reaction Row
                CommentReactionRow(comment: comment)
                    .padding(.top, 4)
                
                // Thread Title Row
                if isAbleShowingThreadView {
                    CommentThreadTitleRow(comment: comment)
                }
            }
        }
        .background(
            Group {
                // NavigationLink to ProfileView
                NavigationLink(destination: ProfileView(userId: comment.userId), isActive: $isShowProfileView) {
                    EmptyView()
                }
                .hidden()
            }
        )
        .background(NavigationLink("", destination: CommentView(comment: comment)).disabled(!isAbleShowingCommentView).opacity(0))
    }
}
