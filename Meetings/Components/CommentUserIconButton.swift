//
//  CommentUserIconButton.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI

struct CommentUserIconButton: View {
    
    // Comment to show
    let comment: Comment
    
    // Navigations
    let isAbleShowingProfileView: Bool
    @State private var isShowProfileView = false
    
    var body: some View {
        Button (action: {
            isShowProfileView.toggle()
        }) {
            UserIconImage(userId: comment.userId, iconImageFamily: .medium)
        }
        .buttonStyle(.borderless)
        .disabled(!isAbleShowingProfileView)
        .background(
            Group {
                // NavigationLink to ProfileView
                NavigationLink(destination: ProfileView(userId: comment.userId), isActive: $isShowProfileView) {
                    EmptyView()
                }
                .hidden()
            }
        )
    }
}
