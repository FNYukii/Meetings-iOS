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
    @State private var commentText = ""
    @State private var commentImages: [UIImage] = []
    
    // Bools
    @State private var isShowImagesPickerView = false
    @State private var isPickingImages = false
    @State private var isLoading = false
    @State private var isShowDialogError = false
    
    // Values
    let commentTextMax = 300
    
    var body: some View {
        NavigationView {
            
            List {
                // TextEditor Row
                MyTextEditor(hintText: Text("comment"), text: $commentText, isFocus: true)
                    .listRowSeparator(.hidden)
                
                // Image Button Row
                Button(action: {
                    isShowImagesPickerView.toggle()
                }) {
                    Image(systemName: "plus")
                    Text("add_images")
                }
                .foregroundColor(.secondary)
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
                
                // Images Row
                ScrollView(.horizontal) {
                    HStack(alignment: .top) {
                        ForEach(0 ..< commentImages.count, id: \.self) { index in
                            Image(uiImage: commentImages[index])
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(8)
                                .frame(height: 120)
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
            .alert("failed", isPresented: $isShowDialogError) {
                Button("ok") {
                    isShowDialogError = false
                }
            } message: {
                Text("comment_creation_failed")
            }
            
            .sheet(isPresented: $isShowImagesPickerView) {
                ImagesPickerView(images: $commentImages, isPicking: $isPickingImages)
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
                            
                            // 画像をアップロード
                            FireImage.uploadImages(images: commentImages, folderName: "images") { imageUrls in
                                // 失敗
                                if imageUrls == nil {
                                    isLoading = false
                                    isShowDialogError = true
                                    return
                                }
                                
                                // 成功
                                // Commentドキュメントを追加
                                FireComment.createComment(threadId: threadId, text: commentText, imageUrls: imageUrls ?? []) { documentId in
                                    // 失敗
                                    if documentId == nil {
                                        isLoading = false
                                        isShowDialogError = true
                                        return
                                    }
                                    
                                    // 成功
                                    dismiss()
                                }
                            }
                        }) {
                            Text("add")
                                .fontWeight(.bold)
                        }
                        .disabled(commentText.isEmpty || commentText.count > commentTextMax)
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
