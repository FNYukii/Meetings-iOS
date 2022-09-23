//
//  SearchResultsSection.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct SearchResultsSection: View {
    
    let keyword: String
    
    @State private var selection = 0
    
    var body: some View {
        Section {
            // Tab Bar Row
            SimpleTabBar(tabBarItems: [Text("threads"), Text("comments"), Text("users")], selection: $selection)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            
            // Tab Body Row
            Group {
                if selection == 0 {
                    SearchedThreadsGroup(keyword: keyword)
                }
                
                if selection == 1 {
                    SearchedCommentsGroup(keyword: keyword)
                }
                
                if selection == 2 {
                    SearchedUsersGroup(keyword: keyword)
                }
            }
            .listRowSeparator(.hidden)
        }
    }
}
