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
    @State private var title = ""
    @State private var tags: [String] = []
    
    @State private var isLoading = false
    @State private var isShowDialogError = false
    
    // Values
    let titleMax = 100
    let tagMax = 30
    let tagsMax = 5
    
    var body: some View {
        NavigationView {
            
            List {
                // TextField Row
                TextField("title", text: $title)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }
                    .disabled(isLoading)
                    .submitLabel(.done)
                    .listRowSeparator(.hidden)
                
                // Tags Row
                ForEach(0 ..< tags.count, id: \.self) { index in
                    HStack {
                        // Image Column
                        Image(systemName: "tag")
                            .foregroundColor(.secondary)
                        
                        // TextField Column
                        TextField("tag", text: $tags[index])
                            .submitLabel(.done)
                        
                        Spacer()
                        
                        // Delete Button Column
                        Button(action: {
                            tags.remove(at: index)
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
                    tags.append("")
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("add_tag")
                    }
                }
                .foregroundColor(.secondary)
                .buttonStyle(.plain)
                .disabled(tags.count >= tagsMax)
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
                            FireThread.createThread(title: title, tags: tags) { documentId in
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
                        .disabled(title.isEmpty || tags.contains(where: {$0.trimmingCharacters(in: .whitespaces).isEmpty}) || title.count > titleMax || tags.contains(where: {$0.count > tagMax}))
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
