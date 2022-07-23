//
//  ProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var signInStateViewModel = SignInStateViewModel()
    
    var body: some View {
        NavigationView {
            
            Group {
                if signInStateViewModel.isLoaded && signInStateViewModel.isSignedIn {
                    ProfileListWhenSignedIn()
                }
                
                if signInStateViewModel.isLoaded && !signInStateViewModel.isSignedIn {
                    ProfileListWhenNotSignedIn()
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
