//
//  EditProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/27.
//

import SwiftUI

struct EditProfileView: View {
    
    // Environments
    @Environment(\.dismiss) private var dismiss
        
    // States
    @State private var displayName = ""
    @State private var userTag = ""
    @State private var introduction = ""
    @State private var iconUrl: String? = nil
    @State private var isLoadedUser = false
    
    // Pick image
    @State private var isShowImagePickerView = false
    @State private var pickedImage: UIImage? = nil
    
    // Loadings, Dialogs
    @State private var isPickingImage = false
    @State private var isLoading = false
    @State private var isShowDialogError = false
    @State private var isShowDialogDuplicate = false
    
    var body: some View {
        NavigationView {
            
            Form {
                Section {
                    HStack {
                        Spacer()
                        
                        // Icon Button
                        Button(action: {
                            isShowImagePickerView.toggle()
                        }) {
                            // Current icon
                            if !isPickingImage && pickedImage == nil {
                                IconImage(url: iconUrl, iconImageFamily: .large)
                            }
                            
                            // Picking view
                            if isPickingImage {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .frame(height: 80)
                            }
                            
                            // New icon
                            if !isPickingImage && pickedImage != nil {
                                Image(uiImage: pickedImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(.infinity)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                        .buttonStyle(.borderless)
                        
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section {
                    TextField("display_name", text: $displayName)
                    TextField("user_tag", text: $userTag)
                }
                
                Section {
                    MyTextEditor(hintText: Text("introduction"), text: $introduction)
                }
            }
            
            .sheet(isPresented: $isShowImagePickerView) {
                ImagePickerView(image: $pickedImage, isPicking: $isPickingImage)
            }
            
            .alert("failed", isPresented: $isShowDialogError) {
                Button("ok") {
                    isShowDialogError = false
                }
            } message: {
                Text("user_updating_failed")
            }
            
            .alert("failed", isPresented: $isShowDialogDuplicate) {
                Button("ok") {
                    isShowDialogDuplicate = false
                }
            } message: {
                Text("user_tag_is_duplicated")
            }
            
            .navigationTitle("edit_profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Update Button
                    if !isLoading {
                        Button(action: {
                            isLoading = true
                            
                            // userTagが重複していないか確認
                            FireUser.readIsUserTagDuplicates(userTag: userTag) { isDuplicate in
                                // 失敗
                                if isDuplicate == nil {
                                    isLoading = false
                                    isShowDialogError = true
                                    return
                                }
                                
                                // 重複あり
                                if isDuplicate == true {
                                    isLoading = false
                                    isShowDialogDuplicate = true
                                    return
                                }
                                
                                // 重複なし
                                // アイコンのアップロードをせずに更新
                                if pickedImage == nil {
                                    // Userドキュメントを更新
                                    FireUser.updateUser(displayName: displayName, userTag: userTag, introduction: introduction, iconUrl: iconUrl) { documentId in
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
                                
                                // 新しいアイコンが選択されていれば更新
                                if let pickedImage = pickedImage {
                                    FireImage.uploadImage(image: pickedImage ,folderName: "icons") { newIconUrl in
                                        // 失敗
                                        if newIconUrl == nil {
                                            isLoading = false
                                            isShowDialogError = true
                                            return
                                        }
                                        
                                        // 成功
                                        // Userドキュメントを更新
                                        FireUser.updateUser(displayName: displayName, userTag: userTag, introduction: introduction, iconUrl: newIconUrl!) { documentId in
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
                                }
                            }
                        }) {
                            Text("done")
                                .fontWeight(.bold)
                        }
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
        .onAppear(perform: load)
    }
    
    private func load() {
        if !isLoadedUser {
            FireUser.readUser(userId: FireAuth.uid()!) { user in
                // 失敗
                if user == nil {
                    // Do nothing
                }
                
                // 成功
                if let user = user {
                    self.displayName = user.displayName
                    self.userTag = user.userTag
                    self.introduction = user.introduction
                    self.iconUrl = user.iconUrl
                    self.isLoadedUser = true
                }
            }
        }
    }
}
