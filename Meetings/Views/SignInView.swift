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
    @State private var isShowDialogError = false
    
    var body: some View {
        NavigationView {
            
            Form {
                TextField("email", text: $email)
                    .keyboardType(.asciiCapable)
                    .disabled(isLoading)
                    .submitLabel(.done)
                
                SecureField("password", text: $password)
                    .disabled(isLoading)
                    .submitLabel(.done)
            }
            
            .alert("failed", isPresented: $isShowDialogError) {
                Button("ok") {
                    isShowDialogError = false
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
                                // 失敗
                                if uid == nil {
                                    isLoading = false
                                    isShowDialogError = true
                                    return
                                }
                                
                                // 成功
                                dismiss()
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
