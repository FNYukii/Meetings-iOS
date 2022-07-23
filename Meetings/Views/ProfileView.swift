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
    
    var body: some View {
        NavigationView {
            
            Group {
                
                if signInStateViewModel.isLoaded && signInStateViewModel.isSignedIn {
                    Text("signed in")
                }
                
                if signInStateViewModel.isLoaded && !signInStateViewModel.isSignedIn {
                    Text("welcome")
                }
                
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
