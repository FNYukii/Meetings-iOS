//
//  ProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var signInStateViewModel = SignInStateViewModel()
    
    @State private var isShowSignUpView = false
    @State private var isShowSignInView = false
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                List {
                    if signInStateViewModel.isLoaded && signInStateViewModel.isSignedIn {
                        Section {
                            HStack {
                                Text("email")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(FireAuth.userEmail()!)
                            }
                        }
                        
                        Section {
                            Button("sign_out") {
                                FireAuth.signOut()
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                
                if signInStateViewModel.isLoaded && !signInStateViewModel.isSignedIn {
                    VStack {
                        Text("sign_in_to_start_using_this_app")
                            .foregroundColor(.secondary)
                        
                        Button("sign_in_to_start") {
                            isShowSignInView.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(.infinity)
                        
                        Button("create_new_account") {
                            isShowSignUpView.toggle()
                        }
                    }
                }
                
            }
            
            .sheet(isPresented: $isShowSignUpView) {
                SignUpView()
            }
            
            .sheet(isPresented: $isShowSignInView) {
                SignInView()
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
