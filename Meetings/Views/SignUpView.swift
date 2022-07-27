//
//  SignUpView.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct SignUpView: View {
    
    // Environments
    @Environment(\.dismiss) private var dismiss
    
    // States
    @State private var email = ""
    @State private var password1 = ""
    @State private var password2 = ""
    @State private var displayName = ""
    @State private var userTag = ""
    @State private var introduction = ""
    @State private var icon: UIImage? = nil
    
    @State private var isLoading = false
    @State private var isShowDialog = false
    
    var body: some View {
        NavigationView {
            
            Form {
                Section {
                    TextField("email", text: $email)
                        .keyboardType(.asciiCapable)
                        .disabled(isLoading)
                    
                    SecureField("password", text: $password1)
                        .disabled(isLoading)
                    
                    SecureField("check_password", text: $password2)
                        .disabled(isLoading)
                }
                
                Section {
                    TextField("display_name", text: $displayName)
                        .disabled(isLoading)
                    
                    TextField("user_tag", text: $userTag)
                        .keyboardType(.asciiCapable)
                        .disabled(isLoading)
                }
                
                Section {
                    MyTextEditor(hintText: Text("introduction"), text: $introduction)
                }
            }
            
            .alert("failed", isPresented: $isShowDialog) {
                Button("ok") {
                    isShowDialog = false
                }
            } message: {
                Text("failed_to_sign_up")
            }
            
            .navigationTitle("new_account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Sign Up Button
                    if !isLoading {
                        Button(action: {
                            // 処理開始
                            isLoading = true
                            // Authenticationによるサインアップ試行
                            FireAuth.signUp(email: email, password: password1) { uid in
                                // 失敗
                                if uid == nil {
                                    isLoading = false
                                    isShowDialog = true
                                    return
                                }
                                
                                // 成功
                                FireUser.createUser(userId: uid!, displayName: displayName, userTag: userTag, introduction: introduction, iconUrl: nil) { documentId in
                                    // 失敗
                                    if documentId == nil {
                                        isLoading = false
                                        isShowDialog = true
                                        FireAuth.signOut()
                                        return
                                    }
                                    
                                    // 成功
                                    dismiss()
                                }
                            }
                        }) {
                            Text("create")
                                .fontWeight(.bold)
                        }
                        .disabled(email.isEmpty || password1.isEmpty || password1 != password2 || displayName.isEmpty || userTag.isEmpty)
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
