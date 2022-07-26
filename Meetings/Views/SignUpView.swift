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
    
    @State private var isShowDialog = false
    
    var body: some View {
        NavigationView {
            
            Form {
                Section {
                    TextField("email", text: $email)
                        .keyboardType(.asciiCapable)
                    SecureField("password", text: $password1)
                    SecureField("check_password", text: $password2)
                }
                
                Section {
                    TextField("display_name", text: $displayName)
                    TextField("user_tag", text: $userTag)
                        .keyboardType(.asciiCapable)
                }
                
                Section {
                    MyTextEditor(hintText: Text("introduction"), text: $introduction)
                }
            }
            
            .alert("failed", isPresented: $isShowDialog) {
                Button("ok") {
                    isShowDialog.toggle()
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // サインアップ試行
                        FireAuth.signUp(email: email, password: password1) { uid in
                            // 失敗
                            if uid == nil {
                                isShowDialog.toggle()
                            }
                            
                            // 成功
                            if let uid = uid {
                                FireUser.createUser(userId: uid, displayName: displayName, userTag: userTag, introduction: introduction, iconUrl: nil)
                                dismiss()
                            }
                        }
                    }) {
                        Text("create")
                            .fontWeight(.bold)
                    }
                    .disabled(email.isEmpty || password1.isEmpty || password1 != password2 || displayName.isEmpty || userTag.isEmpty)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
