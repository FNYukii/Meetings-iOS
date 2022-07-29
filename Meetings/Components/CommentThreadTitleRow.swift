//
//  CommentThreadTitleRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI

struct CommentThreadTitleRow: View {
    
    // Comment to show
    let comment: Comment
    
    // States
    @State private var thread: Thread? = nil
    @State private var isLoadedThread = false
    
    // Navigations
    @State private var isShowThreadView = false
    
    var body: some View {
        Group {
            // Progress view
            if !isLoadedThread {
                Color.secondary
                    .opacity(0.2)
                    .frame(width: 120, height: 16)
            }
            
            // Not found text
            if isLoadedThread && thread == nil {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text("thread_not_found")
                }
                .foregroundColor(.secondary)
            }
            
            // Thread title
            if isLoadedThread && thread != nil {
                Button(action: {
                    isShowThreadView.toggle()
                }) {
                    Text(thread!.title)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.borderless)
            }
        }
        .background(
            Group {
                // NavigationLink to ThreadView
                if thread != nil {
                    NavigationLink(destination: ThreadView(thread: thread!), isActive: $isShowThreadView) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        )
        .onAppear(perform: load)
    }
    
    private func load() {
        // Commentが追加されたThreadを読み取り
        if thread == nil {
            FireThread.readThread(threadId: comment.threadId) { thread in
                self.thread = thread
                self.isLoadedThread = true
            }
        }
    }
}
