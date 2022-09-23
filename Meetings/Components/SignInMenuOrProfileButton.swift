//
//  ProfileButtonOrNot.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct SignInMenuOrProfileButton: View {
    
    // States
    @ObservedObject private var signInStateViewModel = SignInStateViewModel()
    
    // Navigations
    @State private var isShowSignInView = false
    @State private var isShowSignUpView = false
    
    var body: some View {
        Group {
            // Profile Button
            if signInStateViewModel.isSignedIn {
                NavigationLink(destination: UserView(userId: FireAuth.uid()!)) {
                    UserIconImage(userId: FireAuth.uid(), iconImageFamily: .small)
                }
            }
            
            // Sign In Menu
            if !signInStateViewModel.isSignedIn {
                Menu {
                    Button(action: {
                        isShowSignInView.toggle()
                    }) {
                        Label("sign_in", systemImage: "ipad.and.arrow.forward")
                    }
                    
                    Button(action: {
                        isShowSignUpView.toggle()
                    }) {
                        Label("sign_up", systemImage: "square.and.pencil")
                    }
                } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                }
            }
        }
        
        .sheet(isPresented: $isShowSignInView) {
            SignInView()
        }
        
        .sheet(isPresented: $isShowSignUpView) {
            SignUpView()
        }
    }
}
