//
//  ProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var signInStateViewModel = SignInStateViewModel()
    
    @State private var isShowSignUpView = false
    @State private var isShowSignInView = false
    
    var body: some View {
        NavigationView {
            
            Group {
                
                if signInStateViewModel.isLoaded && signInStateViewModel.isSignedIn {
                    VStack {
                        Text("signed in")
                        Button("sign_out") {
                            FireAuth.signOut()
                        }
                    }
                }
                
                if signInStateViewModel.isLoaded && !signInStateViewModel.isSignedIn {
                    VStack {
                        Text("welcome")
                        
                        Button("sign_up") {
                            isShowSignUpView.toggle()
                        }
                        
                        Button("sign_in") {
                            isShowSignInView.toggle()
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

            .navigationTitle("profile")
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
