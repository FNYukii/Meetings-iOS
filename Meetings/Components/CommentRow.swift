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
    
    // States
    @State private var isCommentDeleted = false
    
    // Navigations
    let isAbleShowingProfileView: Bool
    let isShowThread: Bool
    
    // Navigations
    @State private var isShowDialogDelete = false
    @State private var isShowCreateReportView = false
                
    var body: some View {
        
        Group {
            if !isCommentDeleted {
                HStack(alignment: .top, spacing: 8) {
                    
                    // Icon Column
                    UserIconButton(userId: comment.userId, iconSizeFamily: .medium)
                        .disabled(!isAbleShowingProfileView)
                    
                    // Content Column
                    VStack(alignment: .leading) {
                        // Header Row
                        HStack {
                            // Display Name Column
                            UserDisplayNameText(userId: comment.userId)
                            
                            // User Tag Column
                            UserUserTagText(userId: comment.userId)
                            
                            // Date Column
                            EditDate.howManyAgoText(from: comment.createdAt)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            // Menu Column
                            CommentMenu(comment: comment, isCommentDeleted: $isCommentDeleted)
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
                        if isShowThread {
                            CommentThreadTitleRow(comment: comment)
                        }
                    }
                }
                .background(NavigationLink("", destination: CommentView(comment: comment)).opacity(0))
                
                .contextMenu {
                    CommentMenuButtonsGroup(comment: comment, isShowDialogDelete: $isShowDialogDelete, isShowCreateReportView: $isShowCreateReportView)
                }
            }
        }
        
        .confirmationDialog("", isPresented: $isShowDialogDelete, titleVisibility: .hidden) {
            Button("delete_comment", role: .destructive) {
                FireComment.deleteComment(commentId: comment.id) { commentId in
                    // 成功
                    withAnimation {
                        isCommentDeleted = true
                    }
                }
            }
        } message: {
            Text("are_you_sure_you_want_to_delete_this_comment")
        }
        
        .sheet(isPresented: $isShowCreateReportView) {
            CreateReportView(targetId: comment.id, targetFamily: .comment)
        }
    }
}
