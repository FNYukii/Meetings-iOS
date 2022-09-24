//
//  NotificationRow.swift
//  Meetings
//
//  Created by Yu on 2022/09/25.
//

import SwiftUI

struct NotificationRow: View {
    
    // Values
    private let userId = "CRaPxHYz7yUQmltZq6LKw8jXt1u2"
    private let commentId = "0muQhlQs33xVg0FVaPUw"
    
    // States
    @State private var user: User? = nil
    @State private var isLoadedUser = false
    
    @State private var comment: Comment? = nil
    @State private var isLoadedComment = false
    
    var body: some View {
        HStack(alignment: .top) {
            // Header Column
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
            
            // Content Column
            VStack(alignment: .leading) {
                // User Icon Row
                UserIconImage(userId: userId, iconImageFamily: .small)
                
                // Detail Row
                Text("\(user?.displayName ?? "---")さんがあなたのコメントをいいねしました")
                    .fixedSize(horizontal: false, vertical: true)
                // Comment Row
            }
        }
        .onAppear(perform: load)
    }
    
    private func load() {
        if user == nil {
            FireUser.readUser(userId: userId) { user in
                self.user = user
                self.isLoadedUser = true
            }
        }
        
        if comment == nil {
            // TODO: コメントを読み取る
        }
    }
}
