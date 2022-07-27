//
//  ProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct AccountView: View {
    
    // Environments
    @Environment(\.dismiss) private var dismiss
    
    // States
    @State private var isShowDialog = false
    
    var body: some View {
        NavigationView {
            
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
                        Text("••••")
                    }
                }
                
                Section {
                    Button("sign_out") {
                        isShowDialog.toggle()
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
            .confirmationDialog("", isPresented: $isShowDialog, titleVisibility: .hidden) {
                Button("sign_out", role: .destructive) {
                    FireAuth.signOut()
                    dismiss()
                }
            } message: {
                Text("are_you_sure_you_want_to_sign_out")
            }
            
            .navigationTitle("account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("done")
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
