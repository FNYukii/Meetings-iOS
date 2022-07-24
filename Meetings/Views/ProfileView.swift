//
//  ProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct ProfileView: View {
    
    // User to show
    let userId: String
    @State private var user: User? = nil
    
    // States
    @State private var comments: [Comment] = []
    @State private var isCommentsLoaded = false
    
    // Navigation
    @State private var isShowAccountView = false
    
    var body: some View {
        List {
            // Header Row
            HStack(alignment: .top) {
                
                // Icon
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading) {
                    
                    // Progress View
                    if user == nil {
                        Color.secondary.opacity(0.2)
                            .frame(width: 80, height: 16)
                        
                        Color.secondary.opacity(0.2)
                            .frame(width: 80, height: 16)
                    }
                    
                    // DisplayName, userTag
                    if user != nil {
                        Text(user!.displayName)
                            .fontWeight(.bold)
                        
                        Text(user!.userTag)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .listRowSeparator(.hidden)
            
            // Introduction Row
            Group {
                // Progress View
                if user == nil {
                    Color.secondary.opacity(0.2)
                        .frame(width: 200, height: 16)
                }
                
                // Introduction
                if user != nil {
                    Text(user!.introduction)
                }
            }
            
            // Comments Row
            ForEach(comments) { comment in
                CommentRow(comment: comment, isDisableShowingProfileView: true, isShowThreadTitle: true)
            }
        }
        .listStyle(.plain)
        
        .sheet(isPresented: $isShowAccountView) {
            AccountView()
        }
        
        .navigationTitle(user != nil ? user!.displayName : "profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if FireAuth.uid() == userId {
                        Button(action: {
                            
                        }) {
                            Label("edit_profile", systemImage: "person")
                        }
                        
                        Button(action: {
                            isShowAccountView.toggle()
                        }) {
                            Label("account_setting", systemImage: "person")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        
        .onAppear(perform: load)
    }
    
    private func load() {
        // Userを読み取る
        if user == nil {
            FireUser.readUser(userId: userId) { user in
                self.user = user
            }
        }
        
        // Commentsを読み取る
        if !isCommentsLoaded {
            FireComment.readComments(userId: userId) { comments in
                self.comments = comments
            }
        }
    }
}
