//
//  ThreadRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct ThreadRow: View {
    
    // Thread to show
    let thread: Thread
    
    // States
    @State private var firstComment: Comment? = nil
    @State private var isLoadedFirstComment = false
    
    // Dialogs, Navigations
    @State private var isShowDialog = false
    @State private var isShowCreateReportView = false
    
    var body: some View {
        
        HStack(alignment: .top) {
            
            // User Icon Column
            UserIconButton(userId: thread.userId)
            
            // Contents Column
            VStack(alignment: .leading, spacing: 1) {
                
                // Header Row
                HStack(alignment: .top) {
                    
                    // Title Column
                    Text(thread.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    // Menu Column
                    Menu {
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
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                            .padding(.vertical, 6)
                    }
                }
                
                // First Comment Row
                if firstComment != nil {
                    Text(firstComment!.text)
                }
                
                // No First Comment Row
                if isLoadedFirstComment && firstComment == nil {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                        Text("first_comment_reading_failed")
                    }
                    .foregroundColor(.secondary)
                }
                
                // Tags Row
                HStack {
                    UserUserTagText(userId: thread.userId)
                    EditDate.howManyAgoText(from: thread.createdAt)
                        .foregroundColor(.secondary)
                    
                    ForEach(thread.tags, id: \.self) { tag in
                        Text(tag)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .background(NavigationLink("", destination: ThreadView(thread: thread)).opacity(0))
        
        .confirmationDialog("", isPresented: $isShowDialog, titleVisibility: .hidden) {
            Button("delete_thread", role: .destructive) {
                FireThread.deleteThread(threadId: thread.id)
            }
        } message: {
            Text("are_you_sure_you_want_to_delete_this_thread")
        }
        
        .sheet(isPresented: $isShowCreateReportView) {
            CreateReportView(target: .thread)
        }
        
        .onAppear(perform: load)
    }
    
    private func load() {
        // 最初のコメントを読み取るまでタイマーを繰り返す
        var timerCounter = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            timerCounter += 1
            
            // このスレッド上のコメントを読み取り
            if firstComment == nil {
                FireComment.readFirstComment(threadId: thread.id) { comment in
                    self.firstComment = comment
                    self.isLoadedFirstComment = true
                }
            }
            
            // 一定回数読み取りに失敗したらタイマー停止
            if timerCounter == 10 {
                timer.invalidate()
            }
            
            // コメント読み取り後はタイマー停止
            if firstComment != nil {
                timer.invalidate()
            }
        }
    }
}
