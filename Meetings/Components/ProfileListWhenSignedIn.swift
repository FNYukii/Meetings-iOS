//
//  ProfileSections.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct ProfileListWhenSignedIn: View {
    
    @State private var displayName: String = ""
    @State private var userTag: String = ""
    @State private var iconUrl: String? = nil
    @State private var isUserLoaded = false
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("display_name")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(displayName)
                }
                
                HStack {
                    Text("user_tag")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(userTag)
                }
            }
            
            Section {
                NavigationLink(destination: AccountView()) {
                    Text("account_setting")
                }
            }
        }
        .onAppear(perform: load)
    }
    
    private func load() {
        if !isUserLoaded {
            FireUser.readUser(userId: FireAuth.uid()!) { user in
                if let user = user {
                    self.displayName = user.displayName
                    self.userTag = user.userTag
                    self.iconUrl = user.iconUrl
                    self.isUserLoaded = true
                }
            }
        }
    }
}
