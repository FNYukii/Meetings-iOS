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
    @State private var isShowDialogError = false
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                // List Layer
                List {
                    // TextEditor Row
                    MyTextEditor(hintText: Text("text"), text: $text, isFocus: true)
                        .listRowSeparator(.hidden)
                    
                    // Images Row
                    ScrollView(.horizontal) {
                        HStack(alignment: .top) {
                            ForEach(0 ..< pickedImages.count, id: \.self) { index in
                                Image(uiImage: pickedImages[index])
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
                
                // Toolbar Layer
                VStack(spacing: 0) {
                    Spacer()
                    Divider()
                    
                    // Toolbar Row
                    HStack {
                        // Button Column
                        Button(action: {
                            isShowImagesPickerView.toggle()
                        }) {
                            Image(systemName: "photo")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.plain)
                        .padding()
                        
                        Spacer()
                        
                        // Counter Column
                        Text("\(text.count)")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                    .background(Color.black.opacity(0.1))
                }
            }
            
            .alert("failed", isPresented: $isShowDialogError) {
                Button("ok") {
                    isShowDialogError = false
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
                            
                            // 画像をアップロード
                            FireImage.uploadImages(images: pickedImages, folderName: "images") { imageUrls in
                                // 失敗
                                if imageUrls == nil {
                                    isLoading = false
                                    isShowDialogError = true
                                    return
                                }
                                
                                // 成功
                                // Commentドキュメントを追加
                                FireComment.createComment(threadId: threadId, text: text, imageUrls: imageUrls ?? []) { documentId in
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
