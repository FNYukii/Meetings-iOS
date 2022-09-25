//
//  CommentUserIconButton.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI

struct UserIconButton: View {
    
    // Comment to show
    let userId: String?
    let iconSizeFamily: IconImageFamily
    
    // Navigations
    @State private var isShowProfileView = false
    
    var body: some View {
        
        Group {
            if userId == nil {
                Color.secondary
                    .opacity(0.2)
                    .frame(width: iconSizeFamily.rawValue, height: iconSizeFamily.rawValue)
                    .cornerRadius(.infinity)
            }
            
            if userId != nil {
                Button (action: {
                    isShowProfileView.toggle()
                }) {
                    UserIconImage(userId: userId!, iconImageFamily: iconSizeFamily)
                }
                .buttonStyle(.borderless)
                .background(
                    Group {
                        // NavigationLink to ProfileView
                        NavigationLink(destination: UserView(userId: userId!), isActive: $isShowProfileView) {
                            EmptyView()
                        }
                        .hidden()
                    }
                )
            }
        }
    }
}
