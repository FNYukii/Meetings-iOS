//
//  CommentUserIconButton.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI

struct UserIconButton: View {
    
    // Comment to show
    let userId: String
    
    // Navigations
    @State private var isShowProfileView = false
    
    var body: some View {
        Button (action: {
            isShowProfileView.toggle()
        }) {
            UserIconImage(userId: userId, iconImageFamily: .medium)
        }
        .buttonStyle(.borderless)
        .background(
            Group {
                // NavigationLink to ProfileView
                NavigationLink(destination: ProfileView(userId: userId), isActive: $isShowProfileView) {
                    EmptyView()
                }
                .hidden()
            }
        )
    }
}
