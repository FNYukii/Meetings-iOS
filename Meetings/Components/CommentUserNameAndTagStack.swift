//
//  CommentUserNameAndTagStack.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI

struct CommentUserNameAndTagStack: View {
    
    // Comment to show
    let comment: Comment
    
    // Stack Family
    let stackFamily: StackFamily
    
    // States
    @State private var user: User? = nil
    @State private var isLoadedUser = false
    
    var body: some View {
        
        if stackFamily == .hstack {
            HStack {
                
                // Progress views
                if !isLoadedUser {
                    Color.secondary
                        .opacity(0.2)
                        .frame(width: 80)
                    
                    Color.secondary
                        .opacity(0.2)
                        .frame(width: 80)
                }
                
                // User reading failed views
                if isLoadedUser && user == nil {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.secondary)
                    Text("user_reading_failed")
                        .foregroundColor(.secondary)
                }
                
                // Display name & User tag
                if isLoadedUser && user != nil {
                    Text(user!.displayName)
                        .fontWeight(.bold)
                    
                    Text("@\(user!.userTag)")
                        .foregroundColor(.secondary)
                }
            }
            .onAppear(perform: load)
        }
        
        if stackFamily == .vstack {
            VStack {
                // Progress views
                if !isLoadedUser {
                    Color.secondary
                        .opacity(0.2)
                        .frame(width: 80)
                    
                    Color.secondary
                        .opacity(0.2)
                        .frame(width: 80)
                }
                
                // User reading failed views
                if isLoadedUser && user == nil {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.secondary)
                    Text("user_reading_failed")
                        .foregroundColor(.secondary)
                }
                
                // Display name & User tag
                if isLoadedUser && user != nil {
                    Text(user!.displayName)
                        .fontWeight(.bold)
                    
                    Text("@\(user!.userTag)")
                        .foregroundColor(.secondary)
                }
            }
            .onAppear(perform: load)
        }
    }
    
    private func load() {
        // Commentを追加したUserを読み取り
        if user == nil {
            FireUser.readUser(userId: comment.userId) { user in
                self.user = user
                self.isLoadedUser = true
            }
        }
    }
}

enum StackFamily: Int {
    case vstack = 0
    case hstack = 1
    case zstack = 2
}
