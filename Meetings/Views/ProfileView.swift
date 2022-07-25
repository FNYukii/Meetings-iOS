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
    @State private var selection = 0
    @State private var comments: [Comment]? = nil
    
    // Navigation
    @State private var isShowAccountView = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header Row
            HStack(alignment: .top) {
                
                // Icon Column
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.secondary)
                
                // Detail Column
                VStack(alignment: .leading) {
                    
                    // Progress view
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
            .padding(.horizontal)
            
            // Introduction Row
            Group {
                // Progress view
                if user == nil {
                    Color.secondary.opacity(0.2)
                        .frame(width: 200, height: 16)
                }
                
                // Introduction
                if user != nil {
                    Text(user!.introduction)
                }
            }
            .padding(.horizontal)
            
            // Tab Bar Row
            MyTabBar(tabBarItems: [Text("comments"), Text("likes")], selection: $selection)
            
            // Tab Body Row
            TabView(selection: $selection) {
                // Comments Page
                CommentsPage(comments: comments)
                    .tag(0)
                
                // Likes Page
                Text("Likes")
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
            }
        }
        
        // Commentsを読み取る
        if comments == nil {
            FireComment.readComments(userId: userId) { comments in
                self.comments = comments
            }
        }
    }
}
