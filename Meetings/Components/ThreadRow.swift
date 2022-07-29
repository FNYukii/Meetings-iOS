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
    @State private var isLoadedComments = false
    
    // Dialogs, Navigations
    @State private var isShowDialog = false
    @State private var isShowCreateReportView = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // Header Row
            HStack(alignment: .top) {
                Text(thread.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
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
            
            // CommentRows Row
            Group {
                // Progress view
                if !isLoadedComments {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                }
                
                // Reading failed view
                if isLoadedComments && comments == nil {
                    Text("comments_reading_failed")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.secondary)
                }
                
                // No content text
                if isLoadedComments && comments != nil && comments!.count == 0 {
                    Text("no_comments")
                        .foregroundColor(.secondary)
                }
                
                // CommentRows
                if isLoadedComments && comments != nil {
                    ForEach(comments!) { comment in
                        CommentRow(comment: comment, isDisableShowingProfileView: false, isAbleShowingThreadView: false, isAbleShowingCommentView: false)
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
        // このスレッド上のコメントを読み取り
        FireComment.readComments(threadId: thread.id) { comments in
            self.comments = comments
            self.isLoadedComments = true
        }
    }
}
