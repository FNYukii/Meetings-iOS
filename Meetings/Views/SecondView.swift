//
//  SecondView.swift
//  Meetings
//
//  Created by Yu on 2022/09/20.
//

import SwiftUI

struct SecondView: View {
    
    // Search Bar
    @ObservedObject private var searchBar: SearchBar = SearchBar()
    
    // States
    @ObservedObject private var threadsByKeywordViewModel = ThreadsByKeywordViewModel()
    
    // Values
    private let recommendedTags = ["雑談", "天神祭", "ゲーム", "休日", "初心者"]
    
    var body: some View {
        NavigationView {
            List {
                // Searched Threads Section
                Section {
                    if threadsByKeywordViewModel.isLoaded && threadsByKeywordViewModel.threads != nil {
                        ForEach(threadsByKeywordViewModel.threads!) { thread in
                            ThreadRow(thread: thread)
                        }
                    }
                }
                
                // Recommended Tags Section
                if searchBar.text.isEmpty {
                    Section (header: Text("おすすめ")) {
                        ForEach(recommendedTags, id: \.self) { tag in
                            TagRow(name: tag)
                                .listRowSeparator(.hidden, edges: .top)
                                .listRowSeparator(.visible, edges: .bottom)
                        }
                    }
                }
            }
            .listStyle(.plain)
            
            .add(searchBar)
            .onChange(of: searchBar.text) { _ in
                threadsByKeywordViewModel.read(keyword: searchBar.text)
            }
            
            .navigationTitle("search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
