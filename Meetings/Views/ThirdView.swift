//
//  ThirdView.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct ThirdView: View {
    
    @ObservedObject private var signInStateViewModel = SignInStateViewModel()
    
    var body: some View {
        NavigationView {
            
            Group {
                if !signInStateViewModel.isSignedIn {
                    List {
                        Text("no_notifications")
                        Text("please_sign_in")
                    }
                    .listStyle(.plain)
                }
                
                if signInStateViewModel.isSignedIn {
                    NotificationsList()
                }
            }
            .navigationTitle("notifications")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    SignInMenuOrProfileButton()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
