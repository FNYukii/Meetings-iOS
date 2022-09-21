//
//  SearchedUsersGroup.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct SearchedUsersGroup: View {
    
    let keyword: String
    
    @State private var users: [User]? = nil
    @State private var isLoadedUser = false
    
    var body: some View {
        Group {
            // Progress
            if !isLoadedUser {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }

            // Failed
            if isLoadedUser && users == nil {
                Text("reading_failed")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }

            // No Results
            if isLoadedUser && users != nil && users!.count == 0 {
                Text("no_results")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }

            // Done
            if isLoadedUser && users != nil {
                ForEach(users!) { user in
                    UserRow(user: user)
                        .listRowSeparator(.hidden, edges: .top)
                        .listRowSeparator(.visible, edges: .bottom)
                }
            }
        }
        .onAppear(perform: load)
    }
    
    private func load() {
        if users == nil {
            FireUser.readUsers(keyword: keyword) { users in
                self.users = users
                self.isLoadedUser = true
            }
        }
    }
}
