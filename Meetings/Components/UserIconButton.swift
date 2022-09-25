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
    let iconImageFamily: IconImageFamily
    
    // Navigations
    @State private var isShowProfileView = false
    
    var body: some View {
        Button (action: {
            isShowProfileView.toggle()
        }) {
            UserIconImage(userId: userId, iconImageFamily: iconImageFamily)
        }
        .buttonStyle(.borderless)
        .background(
            Group {
                // NavigationLink to ProfileView
                NavigationLink(destination: UserView(userId: userId), isActive: $isShowProfileView) {
                    EmptyView()
                }
                .hidden()
            }
        )
    }
}
