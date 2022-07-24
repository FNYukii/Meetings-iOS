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
    
    // User to show
    @State private var user: User? = nil
    
    // Navigation to views
    @State private var isShowAccountView = false
    
    var body: some View {
        List {
            HStack(alignment: .top) {
                
                // Icon
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading) {
                    
                    // ProgressView
                    if user == nil {
                        Color.secondary.opacity(0.2)
                            .frame(width: 80)
                        
                        Color.secondary.opacity(0.2)
                            .frame(width: 80)
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
            
            // ProgressView
            if user == nil {
                Color.secondary.opacity(0.2)
                    .frame(width: 200)
                    .listRowSeparator(.hidden)
            }
            
            // Introduction
            if user != nil {
                Text(user!.introduction)
                    .listRowSeparator(.hidden)
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
    }
}
