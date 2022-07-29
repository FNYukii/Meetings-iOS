//
//  UserIconImage.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserIconImage: View {
    
    // User ID to show
    let userId: String
    
    // Icon size
    let iconImageFamily: IconImageFamily
    
    // States
    @State private var user: User? = nil
    @State private var isLoadedUser = false
    
    var body: some View {
        WebImage(url: URL(string: user != nil ? user!.iconUrl ?? "" : ""))
            .resizable()
            .placeholder {
                Color.secondary
                    .opacity(0.2)
            }
            .scaledToFill()
            .frame(width: iconImageFamily.rawValue, height: iconImageFamily.rawValue)
            .cornerRadius(.infinity)
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
            .onAppear(perform: load)
    }
    
    private func load() {
        // Commentを追加したUserを読み取り
        if user == nil {
            FireUser.readUser(userId: userId) { user in
                self.user = user
                self.isLoadedUser = true
            }
        }
    }
}

enum IconImageFamily: CGFloat {
    case small = 32
    case medium = 40
    case large = 80
}
