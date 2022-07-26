//
//  SignOutView.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct SignInView: View {
    
    // Environments
    @Environment(\.dismiss) private var dismiss
    
    // States
    @State private var email = ""
    @State private var password = ""
    
    @State private var isLoading = false
    @State private var isShowDialog = false
    
    var body: some View {
        NavigationView {
            
            Form {
                TextField("email", text: $email)
                    .keyboardType(.asciiCapable)
                    .disabled(isLoading)
                
                SecureField("password", text: $password)
                    .disabled(isLoading)
            }
            
            .alert("failed", isPresented: $isShowDialog) {
                Button("ok") {
                    isShowDialog = false
                }
            } message: {
                Text("failed_to_sign_up")
            }
            
            .navigationTitle("sign_in")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Sign In Button
                    if !isLoading {
                        Button(action: {
                            isLoading = true
                            // サインイン試行
                            FireAuth.signIn(email: email, password: password) { uid in
                                isLoading = false
                                // 失敗
                                if uid == nil {
                                    isShowDialog = true
                                }
                                
                                // 成功
                                if uid != nil {
                                    dismiss()
                                }
                            }
                        }) {
                            Text("sign_in")
                                .fontWeight(.bold)
                        }
                        .disabled(email.isEmpty || password.isEmpty)
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
