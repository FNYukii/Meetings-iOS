//
//  SignOutView.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct SignInView: View {
    
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        NavigationView {
            
            Form {
                TextField("email", text: $email)
                SecureField("password", text: $password)
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
                        FireAuth.signIn(email: email, password: password)
                        dismiss()
                    }) {
                        Text("done")
                            .fontWeight(.bold)
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}
