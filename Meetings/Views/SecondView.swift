//
//  SecondView.swift
//  Meetings
//
//  Created by Yu on 2022/09/20.
//

import SwiftUI

struct SecondView: View {
    
    // Search Bar
    @State private var keyword = ""
    
    // States
    @ObservedObject private var threadsByKeywordViewModel = ThreadsByKeywordViewModel()
    
    // Values
    private let recommendedTags = ["雑談", "天神祭", "ゲーム", "休日", "初心者"]
    
    var body: some View {
        NavigationView {
            List {
                // Searched Threads Section
                Section {
                    // Progress
                    if !keyword.isEmpty && !threadsByKeywordViewModel.isLoaded {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .listRowSeparator(.hidden)
                    }
                    
                    // Failed
                    if threadsByKeywordViewModel.isLoaded && threadsByKeywordViewModel.threads == nil {
                        Text("threads_reading_failed")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.secondary)
                            .listRowSeparator(.hidden)
                    }
                    
                    // No content
                    if threadsByKeywordViewModel.isLoaded && threadsByKeywordViewModel.threads != nil && threadsByKeywordViewModel.threads!.count == 0 {
                        Text("no_threads")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.secondary)
                            .listRowSeparator(.hidden)
                    }
                    
                    // Done
                    if threadsByKeywordViewModel.isLoaded && threadsByKeywordViewModel.threads != nil {
                        ForEach(threadsByKeywordViewModel.threads!) { thread in
                            ThreadRow(thread: thread)
                                .listRowSeparator(.hidden, edges: .top)
                                .listRowSeparator(.visible, edges: .bottom)
                        }
                    }
                }
                
                // Recommended Tags Section
                if keyword.isEmpty {
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
            
            .searchable(text: $keyword)
            .onChange(of: keyword) { _ in
                threadsByKeywordViewModel.read(keyword: keyword)
            }
            
            .navigationTitle("search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
