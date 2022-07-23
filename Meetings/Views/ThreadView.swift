//
//  ThreadView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct ThreadView: View {
    
    @State private var isShowCreateCommentView = false
    
    let thread: Thread
    
    var body: some View {
        List {
            
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
