//
//  ProfileListWhenNotSignedIn.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct ProfileListWhenNotSignedIn: View {
    
    @State private var isShowSignInView = false
    @State private var isShowSignUpView = false
    
    var body: some View {
        
        ZStack {
            
            List {
                EmptyView()
            }
            
            VStack {
                Text("sign_in_to_use_app_more")
                    .foregroundColor(.secondary)
                
                Button("sign_in_to_start") {
                    isShowSignInView.toggle()
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 48)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(48)
                
                Button("create_new_account") {
                    isShowSignUpView.toggle()
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
