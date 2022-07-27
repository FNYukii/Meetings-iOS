//
//  CreateThreadView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct CreateThreadView: View {
    
    // Environments
    @Environment(\.dismiss) private var dismiss
    
    // States
    @State private var title = ""
    
    @State private var isLoading = false
    @State private var isShowDialog = false
    
    var body: some View {
        NavigationView {
            
            Form {
                TextField("title", text: $title)
                    .disabled(isLoading)
            }
            
            .alert("failed", isPresented: $isShowDialog) {
                Button("ok") {
                    isShowDialog = false
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
                            FireThread.createThread(title: title) { documentId in
                                isLoading = false
                                // 失敗
                                if documentId == nil {
                                    isShowDialog = true
                                }
                                
                                // 成功
                                if documentId != nil {
                                    dismiss()
                                }
                            }
                        }) {
                            Text("create")
                                .fontWeight(.bold)
                        }
                        .disabled(title.isEmpty)
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
