//
//  ProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct ProfileView: View {
    
    // User ID to show
    let userId: String
    
    // States
    @State private var user: User? = nil
    @State private var isLoadedUser = false
    
    @State private var selection = 0
    @State private var postedComments: [Comment]? = nil
    @State private var likedComments: [Comment]? = nil
    
    // Navigation
    @State private var isShowAccountView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Row
            HStack(alignment: .top) {
                
                // Icon Column
                IconImage(url: user?.iconUrl, iconImageFamily: .medium)
                
                // Detail Column
                VStack(alignment: .leading) {
                    
                    // Progress view
                    if !isLoadedUser {
                        Color.secondary
                            .opacity(0.2)
                            .frame(width: 80, height: 16)
                        
                        Color.secondary
                            .opacity(0.2)
                            .frame(width: 80, height: 16)
                    }
                    
                    // Not found view
                    if isLoadedUser && user == nil {
                        EmptyView()
                    }
                    
                    // DisplayName, userTag
                    if isLoadedUser && user != nil {
                        Text(user!.displayName)
                            .fontWeight(.bold)
                        
                        Text(user!.userTag)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
            
            // User Not Found Row
            if isLoadedUser && user == nil {
                Text("user_not_found")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
            }
            
            // Introduction Row
            Group {
                // Progress view
                if !isLoadedUser {
                    Color.secondary
                        .opacity(0.2)
                        .frame(width: 200, height: 16)
                }
                
                // Introduction
                if isLoadedUser && user != nil {
                    Text(user!.introduction)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Tab Bar Row
            MyTabBar(tabBarItems: [Text("posts"), Text("likes")], selection: $selection)
            
            // Tab Body Row
            TabView(selection: $selection) {
                // Comments Page
                CommentRowList(comments: postedComments)
                    .tag(0)
                
                // Likes Page
                CommentRowList(comments: likedComments)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.spring(), value: selection)
        }
        
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
                self.isLoadedUser = true
            }
        }
        
        // ユーザーが投稿したCommentsを読み取る
        if postedComments == nil {
            FireComment.readPostedComments(userId: userId) { comments in
                self.postedComments = comments
            }
        }
        
        // ユーザーがいいねしたコメントを読み取る
        if likedComments == nil {
            FireComment.readLikedComments(userId: userId) { comment in
                self.likedComments = comment
            }
        }
    }
}
