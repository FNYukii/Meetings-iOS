//
//  CommentRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct CommentRow: View {
    
    // Comment to show
    let comment: Comment
    
    // Navigations
    let isAbleShowingProfileView: Bool
    let isAbleShowingThreadView: Bool
    let isAbleShowingCommentView: Bool
    
    @State private var isShowProfileView = false
    
    // States
    @State private var user: User? = nil
    @State private var isLoadedUser = false
        
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            
            // Icon Column
            Button (action: {
                isShowProfileView.toggle()
            }) {
                IconImage(url: user?.iconUrl, iconImageFamily: .medium)
            }
            .buttonStyle(.borderless)
            .disabled(!isAbleShowingProfileView)
            
            // Content Column
            VStack(alignment: .leading) {
                
                // Header Row
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
                    
                    // Date text
                    EditDate.howManyAgoText(from: comment.createdAt)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    CommentMenu(comment: comment)
                }
                
                // Text Row
                Text(comment.text)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Images Row
                CommentImagesRow(comment: comment)
                
                // Reaction Row
                CommentReactionRow(comment: comment)
                    .padding(.top, 4)
                
                // Thread Title Row
                if isAbleShowingThreadView {
                    CommentThreadTitleRow(comment: comment)
                }
            }
        }
        .background(
            Group {
                // NavigationLink to ProfileView
                NavigationLink(destination: ProfileView(userId: comment.userId), isActive: $isShowProfileView) {
                    EmptyView()
                }
                .hidden()
            }
        )
        .background(NavigationLink("", destination: CommentView(comment: comment)).disabled(!isAbleShowingCommentView).opacity(0))
        .onAppear(perform: load)
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
