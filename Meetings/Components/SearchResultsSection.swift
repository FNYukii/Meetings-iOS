//
//  SearchResultsSection.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct SearchResultsSection: View {
    
    @State private var selection = 0
    
    var body: some View {
        Section {
            FluentTabBar(tabBarItems: [Text("threads"), Text("tag"), Text("comments"), Text("users")], selection: $selection)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
        }
    }
}
