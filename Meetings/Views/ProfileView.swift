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
                            isShowSignInView.toggle()
                        }
                    }
                    
                }
                
            }
            
            .sheet(isPresented: $isShowSignInView) {
                SignUpView()
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
