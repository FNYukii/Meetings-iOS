//
//  SecondView.swift
//  Meetings
//
//  Created by Yu on 2022/09/20.
//

import SwiftUI

struct SecondView: View {
    
    // Search Bar
    @ObservedObject var searchBar: SearchBar = SearchBar()
    
    // Values
    let recommendedTags = ["雑談", "天神祭", "ゲーム", "休日", "初心者"]
    
    var body: some View {
        NavigationView {
            List {
                Section (header: Text("おすすめ")) {
                    ForEach(recommendedTags, id: \.self) { tag in
                        TagRow(name: tag)
                            .listRowSeparator(.hidden, edges: .top)
                            .listRowSeparator(.visible, edges: .bottom)
                    }
                }
            }
            .listStyle(.plain)
            
            .add(searchBar)
            .onChange(of: searchBar.text) { _ in
                
            }
            
            .navigationTitle("search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
