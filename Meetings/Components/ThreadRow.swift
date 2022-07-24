//
//  ThreadRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct ThreadRow: View {
    
    let thread: Thread
    
    @State private var comments: [Comment] = []
    @State private var isCommentsLoaded = false
    @State private var isShowDialog = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            // Header
            HStack(alignment: .top) {
                Text(thread.title)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Menu {
                    if FireAuth.uid() == thread.userId {
                        Button(role: .destructive) {
                            isShowDialog.toggle()
                        } label: {
                            Label("delete_thread", systemImage: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                        .padding(.vertical, 6)
                }
            }
            
            // ProgressView
            if !isCommentsLoaded {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                }
            }
            
            // Comments
            if isCommentsLoaded {
                ForEach(comments) { comment in
                    CommentRow(comment: comment)
                }
            }
            
            // 0 Comment Message
            if isCommentsLoaded && comments.count == 0 {
                Text("0_Comments")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.bottom)
        .background( NavigationLink("", destination: ThreadView(thread: thread)).opacity(0))
        
        .confirmationDialog("", isPresented: $isShowDialog, titleVisibility: .hidden) {
            Button("delete_thread", role: .destructive) {
                FireThread.deleteThread(threadId: thread.id)
            }
        } message: {
            Text("are_you_sure_you_want_to_delete_this_thread")
        }
        
        .onAppear(perform: load)
    }
    
    private func load() {
        // このスレッド上のコメントを読み取り
        if !isCommentsLoaded {
            FireComment.readComments(threadId: thread.id) { comments in
                withAnimation {
                    self.comments = comments
                    self.isCommentsLoaded = true
                }
            }
        }
    }
}
