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
    @State private var comments: [Comment]? = []
    @State private var isShowDialog = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // Header Row
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
            
            // CommentRows Row
            Group {
                // Progress view
                if comments == nil {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                }
                
                // CommentRows
                if comments != nil {
                    ForEach(comments!) { comment in
                        CommentRow(comment: comment, isDisableShowingProfileView: false, isAbleShowingThreadView: false)
                    }
                }
            }
            
            // 0 Comment Message Row
            if comments != nil && comments!.count == 0 {
                Text("0_Comments")
                    .foregroundColor(.secondary)
            }
        }
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
        FireComment.readComments(threadId: thread.id) { comments in
            withAnimation {
                self.comments = comments
            }
        }
    }
}
