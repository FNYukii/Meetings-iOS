//
//  CreateCommentView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct CreateCommentView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let threadId: String
    @State private var text = ""
    
    var body: some View {
        NavigationView {
            
            Form {
                MyTextEditor(hintText: Text("text"), text: $text)
            }
            
            .navigationTitle("new_comment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        FireComment.createComment(threadId: threadId, text: text)
                        dismiss()
                    }) {
                        Text("add")
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

