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
    
    // Navigation
    @State private var isShowEditProfileView = false
    @State private var isShowAccountView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Row
            HStack(alignment: .top) {
                
                // Icon Column
                IconImage(url: user?.iconUrl, iconImageFamily: .medium)
                
                // DisplayName And UserTag Column
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
                    
                    // Reading failed view
                    if isLoadedUser && user == nil {
                        EmptyView()
                    }
                    
                    // DisplayName, UserTag
                    if isLoadedUser && user != nil {
                        Text(user!.displayName)
                            .fontWeight(.bold)
                        
                        Text("@\(user!.userTag)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
            
            // User Reading Failed Row
            if isLoadedUser && user == nil {
                Text("user_reading_failed")
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
                
                // Reading failed view
                if isLoadedUser && user == nil {
                    EmptyView()
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
                CommentRowList(userId: userId, commentRowListFamily: .posts)
                    .tag(0)
                
                // Likes Page
                CommentRowList(userId: userId, commentRowListFamily: .likes)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.spring(), value: selection)
        }
        
        .sheet(isPresented: $isShowEditProfileView) {
            EditProfileView()
        }
        
        .sheet(isPresented: $isShowAccountView) {
            AccountView()
        }
        
        .navigationTitle("profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if FireAuth.uid() == userId {
                        Button(action: {
                            isShowEditProfileView.toggle()
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
    }
}
