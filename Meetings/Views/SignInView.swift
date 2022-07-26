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
    
    @State private var isShowDialog = false
    
    var body: some View {
        NavigationView {
            
            Form {
                TextField("email", text: $email)
                SecureField("password", text: $password)
            }
            
            .alert("failed", isPresented: $isShowDialog) {
                Button("ok") {
                    isShowDialog.toggle()
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // サインイン試行
                        FireAuth.signIn(email: email, password: password) { uid in
                            // 失敗
                            if uid == nil {
                                isShowDialog.toggle()
                            }
                            
                            // 成功
                            if uid != nil {
                                dismiss()
                            }
                        }
                    }) {
                        Text("done")
                            .fontWeight(.bold)
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
}
