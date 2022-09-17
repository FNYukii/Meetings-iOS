//
//  CommentDisplayNameText.swift
//  Meetings
//
//  Created by Yu on 2022/09/16.
//

import SwiftUI

struct UserDisplayNameText: View {
    
    // User ID to show
    let userId: String
    
    // States
    @State private var user: User? = nil
    @State private var isLoadedUser = false
    
    var body: some View {
        
        Group {
            // Progress views
            if !isLoadedUser {
                Color.secondary
                    .opacity(0.2)
                    .frame(width: 80)
            }
            
            // User reading failed views
            if isLoadedUser && user == nil {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.secondary)
            }
            
            // Display name
            if isLoadedUser && user != nil {
                Text(user!.displayName)
                    .fontWeight(.bold)
            }
        }
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
