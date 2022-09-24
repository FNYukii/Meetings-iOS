//
//  CommentMenu.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI

struct CommentMenu: View {
    
    // Comment to show
    let comment: Comment
    @Binding var isCommentDeleted: Bool
    
    // Navigations
    @State private var isShowDialogDelete = false
    @State private var isShowCreateReportView = false
    
    var body: some View {
        Menu {
            // 削除ボタン
            if FireAuth.uid() == comment.userId {
                Button(role: .destructive) {
                    isShowDialogDelete.toggle()
                } label: {
                    Label("delete_comment", systemImage: "trash")
                }
            }
            
            // 報告ボタン
            if FireAuth.uid() != comment.userId {
                Button(action: {
                    isShowCreateReportView.toggle()
                }) {
                    Label("report_comment", systemImage: "flag")
                }
            }
            
            // Mute Button
            if FireAuth.uid() != comment.userId {
                Button(action: {
                    
                }) {
                    Label("mute_user", systemImage: "speaker.slash")
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .padding(.vertical, 6)
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
