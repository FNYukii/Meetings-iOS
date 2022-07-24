//
//  ProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        List {
            Section {
                HStack {
                    Text("email")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(FireAuth.userEmail() != nil ? FireAuth.userEmail()! : "")
                }
                
                HStack {
                    Text("password")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("kjflakjfldkajl")
                }
            }
            
            Section {
                Button("sign_out") {
                    FireAuth.signOut()
                    dismiss()
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        
        .navigationTitle("account")
        .navigationBarTitleDisplayMode(.inline)
    }
}
