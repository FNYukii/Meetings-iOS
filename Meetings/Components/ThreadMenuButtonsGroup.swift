//
//  ThreadMenuButtonsGroup.swift
//  Meetings
//
//  Created by Yu on 2022/09/26.
//

import SwiftUI

struct ThreadMenuButtonsGroup: View {
    
    let thread: Thread
    @Binding var isThreadDeleted: Bool
    
    // Dialogs, Navigations
    @Binding var isShowDialog: Bool
    @Binding var isShowCreateReportView: Bool
    
    var body: some View {
        Group {
            // 削除ボタン
            if FireAuth.uid() == thread.userId {
                Button(role: .destructive) {
                    isShowDialog.toggle()
                } label: {
                    Label("delete_thread", systemImage: "trash")
                }
            }
            
            // 報告ボタン
            if FireAuth.uid() != thread.userId {
                Button(action: {
                    isShowCreateReportView.toggle()
                }) {
                    Label("report_thread", systemImage: "flag")
                }
            }
        }
    }
}
