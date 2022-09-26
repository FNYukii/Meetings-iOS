//
//  CommentMenuButtonsGroup.swift
//  Meetings
//
//  Created by Yu on 2022/09/26.
//

import SwiftUI

struct CommentMenuButtonsGroup: View {
    
    let comment: Comment
    
    @Binding var isShowDialogDelete: Bool
    @Binding var isShowCreateReportView: Bool
        
    var body: some View {
        Group {
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
        }
    }
}
