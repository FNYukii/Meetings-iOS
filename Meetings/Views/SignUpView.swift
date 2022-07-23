//
//  SignUpView.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password1 = ""
    @State private var password2 = ""
    @State private var displayName = ""
    @State private var userTag = ""
    @State private var icon: UIImage? = nil
    
    var body: some View {
        NavigationView {
            
            Form {
                Section {
                    TextField("email", text: $email)
                    SecureField("password", text: $password1)
                    SecureField("check_password", text: $password2)
                }
                
                Section {
                    TextField("display_name", text: $displayName)
                    TextField("user_tag", text: $userTag)
                }
            }
            
            .navigationTitle("sign_up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        FireAuth.signUp(email: email, password: password1) { uid in
                            FireUser.createUser(userId: uid, displayName: displayName, userTag: userTag, iconPath: nil)
                        }
                        dismiss()
                    }) {
                        Text("done")
                            .fontWeight(.bold)
                    }
                    .disabled(email.isEmpty || password1.isEmpty || password1 != password2 || displayName.isEmpty || userTag.isEmpty)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
