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
    @State private var isShowDialogError = false
    
    var body: some View {
        NavigationView {
            
            Form {
                Section {
                    TextField("email", text: $email)
                        .keyboardType(.asciiCapable)
                        .disabled(isLoading)
                        .submitLabel(.done)
                    
                    SecureField("password", text: $password1)
                        .disabled(isLoading)
                        .submitLabel(.done)
                    
                    SecureField("check_password", text: $password2)
                        .disabled(isLoading)
                        .submitLabel(.done)
                }
                
                Section {
                    TextField("display_name", text: $displayName)
                        .disabled(isLoading)
                        .submitLabel(.done)
                    
                    TextField("user_tag", text: $userTag)
                        .keyboardType(.asciiCapable)
                        .disabled(isLoading)
                        .submitLabel(.done)
                }
                
                Section {
                    GuidedTextEditor(hintText: Text("introduction"), text: $introduction, isFocus: false)
                }
            }
            
            .alert("failed", isPresented: $isShowDialogError) {
                Button("ok") {
                    isShowDialogError = false
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
                                    isShowDialogError = true
                                    return
                                }
                                
                                // 成功
                                FireUser.createUser(userId: uid!, displayName: displayName, userTag: userTag, introduction: introduction, iconUrl: nil) { documentId in
                                    // 失敗
                                    if documentId == nil {
                                        isLoading = false
                                        isShowDialogError = true
                                        FireAuth.signOut()
                                        return
                                    }
                                    
                                    // 成功
                                    dismiss()
                                    
                                    // TODO: dismissされないバグを解決
                                    isLoading = false
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
