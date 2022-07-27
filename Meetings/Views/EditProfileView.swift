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
    
    @State private var isLoading = false
    @State private var isShowDialogError = false
    @State private var isShowDialogDuplicate = false
    
    var body: some View {
        NavigationView {
            
            Form {
                Section {
                    TextField("display_name", text: $displayName)
                    TextField("user_tag", text: $userTag)
                }
                
                Section {
                    MyTextEditor(hintText: Text("introduction"), text: $introduction)
                }
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
                                }
                                
                                // 重複あり
                                if isDuplicate == true {
                                    isLoading = false
                                    isShowDialogDuplicate = true
                                }
                                
                                // 重複なし
                                FireUser.updateUser(displayName: displayName, userTag: userTag, introduction: introduction, iconUrl: iconUrl) { documentId in
                                    // 失敗
                                    if documentId == nil {
                                        isLoading = false
                                        isShowDialogError = true
                                    }
                                    
                                    // 成功
                                    if documentId != nil {
                                        dismiss()
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
                
                // 成功
                if let user = user {
                    self.displayName = user.displayName
                    self.userTag = user.userTag
                    self.introduction = user.introduction
                    self.iconUrl = user.iconUrl
                }
            }
        }
    }
}
