//
//  CreateThreadView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI
import Introspect

struct CreateThreadView: View {
    
    // Environments
    @Environment(\.dismiss) private var dismiss
    
    // States
    @State private var threadTitle = ""
    @State private var threadTags: [String] = []
    @State private var commentText = ""
    
    @State private var isLoading = false
    @State private var isShowDialogError = false
    
    // Values
    let threadTitleMax = 100
    let threadTagMax = 30
    let threadTagsMax = 5
    
    var body: some View {
        NavigationView {
            
            List {
                // TextField Row
                TextField("title", text: $threadTitle)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }
                    .disabled(isLoading)
                    .submitLabel(.done)
                    .listRowSeparator(.hidden)
                
                // Tags Row
                ForEach(0 ..< threadTags.count, id: \.self) { index in
                    HStack {
                        // Image Column
                        Image(systemName: "tag")
                            .foregroundColor(.secondary)
                        
                        // TextField Column
                        TextField("tag", text: $threadTags[index])
                            .submitLabel(.done)
                        
                        Spacer()
                        
                        // Delete Button Column
                        Button(action: {
                            threadTags.remove(at: index)
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    .listRowSeparator(.hidden)
                }
                
                // Add Tag Button Row
                Button(action: {
                    withAnimation {
                        threadTags.append("")
                    }
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("add_tag")
                    }
                }
                .foregroundColor(.secondary)
                .buttonStyle(.plain)
                .disabled(threadTags.count >= threadTagsMax)
                .listRowSeparator(.hidden)
                
                // Comment Text Row
                MyTextEditor(hintText: Text("comment"), text: $commentText, isFocus: false)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
            .alert("failed", isPresented: $isShowDialogError) {
                Button("ok") {
                    isShowDialogError = false
                }
            } message: {
                Text("thread_creation_failed")
            }
            
            .navigationTitle("new_thread")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Create Button
                    if !isLoading {
                        Button(action: {
                            isLoading = true
                            FireThread.createThread(title: threadTitle, tags: threadTags) { documentId in
                                // 失敗
                                if documentId == nil {
                                    isLoading = false
                                    isShowDialogError = true
                                }
                                
                                // 成功
                                dismiss()
                            }
                        }) {
                            Text("create")
                                .fontWeight(.bold)
                        }
                        .disabled(threadTitle.isEmpty || threadTags.contains(where: {$0.trimmingCharacters(in: .whitespaces).isEmpty}) || threadTitle.count > threadTitleMax || threadTags.contains(where: {$0.count > threadTagMax}))
                    }
                    
                    // ProgressView
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
