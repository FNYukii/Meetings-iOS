//
//  CreateCommentView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct CreateCommentView: View {
    
    // Environments
    @Environment(\.dismiss) private var dismiss
    
    // Thread ID to input comment
    let threadId: String
    
    // States
    @State private var text = ""
    @State private var pickedImages: [UIImage] = []
    
    // Bools
    @State private var isShowImagesPickerView = false
    @State private var isPickingImages = false
    @State private var isLoading = false
    @State private var isShowDialog = false
    
    var body: some View {
        NavigationView {
            
            Form {
                Section {
                    MyTextEditor(hintText: Text("text"), text: $text)
                }
                
                Section {
                    // Pick Button
                    if !isPickingImages {
                        Button(action: {
                            isShowImagesPickerView.toggle()
                        }) {
                            Text("pick_images")
                        }
                    }
                    
                    // ProgressView
                    if isPickingImages {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
            }
            
            .alert("failed", isPresented: $isShowDialog) {
                Button("ok") {
                    isShowDialog = false
                }
            } message: {
                Text("comment_creation_failed")
            }
            
            .sheet(isPresented: $isShowImagesPickerView) {
                ImagesPickerView(images: $pickedImages, isPicking: $isPickingImages)
            }
            
            .navigationTitle("new_comment")
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
                            FireComment.createComment(threadId: threadId, text: text) { documentId in
                                // 失敗
                                if documentId == nil {
                                    isLoading = false
                                    isShowDialog = true
                                }
                                
                                // 成功
                                dismiss()
                            }
                        }) {
                            Text("add")
                                .fontWeight(.bold)
                        }
                        .disabled(text.isEmpty)
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

