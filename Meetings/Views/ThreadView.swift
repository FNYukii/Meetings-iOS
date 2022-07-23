//
//  ThreadView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct ThreadView: View {
    
    private let thread: Thread
    
    @ObservedObject private var commentsViewModel: CommentsViewModel
    @State private var isShowCreateCommentView = false
    
    init(thread: Thread) {
        self.thread = thread
        self.commentsViewModel = CommentsViewModel(threadId: thread.id)
    }

    var body: some View {
        List {
            ForEach(commentsViewModel.comments) { comment in
                Text(comment.text)
            }
        }
        
        .sheet(isPresented: $isShowCreateCommentView) {
            CreateCommentView(threadId: thread.id)
        }
        
        .navigationTitle(thread.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowCreateCommentView.toggle()
                }) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
    }
}
