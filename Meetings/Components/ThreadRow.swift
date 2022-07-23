//
//  ThreadRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct ThreadRow: View {
    
    let thread: Thread
    
    @State private var isShowDialog = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Text(thread.title)
                    .fontWeight(.bold)
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
            
            Text("0 Comments")
                .foregroundColor(.secondary)
        }
        .background( NavigationLink("", destination: ThreadView(thread: thread)).opacity(0))
        
        .confirmationDialog("", isPresented: $isShowDialog, titleVisibility: .hidden) {
            Button("delete_thread", role: .destructive) {
                FireThread.deleteThread(threadId: thread.id)
            }
        } message: {
            Text("are_you_sure_you_want_to_delete_this_thread")
        }
    }
}
