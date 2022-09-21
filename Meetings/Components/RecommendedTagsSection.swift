//
//  RecommendTagSection.swift
//  Meetings
//
//  Created by Yu on 2022/09/20.
//

import SwiftUI

struct RecommendedTagsSection: View {
        
    @State private var recentlyUsedTags: [String]? = nil
    @State private var isLoaded = false
    
    @Binding var keyword: String
    
    var body: some View {
        Section (header: Text("recent")) {
            // Progress
            if !isLoaded {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }

            // Failed
            if isLoaded && recentlyUsedTags == nil {
                Text("reading_failed")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }

            // No Results
            if isLoaded && recentlyUsedTags != nil && recentlyUsedTags!.count == 0 {
                Text("no_results")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }

            // Done
            if isLoaded && recentlyUsedTags != nil {
                ForEach(recentlyUsedTags!, id: \.self) { tag in
                    TagRow(word: tag, keyword: $keyword)
                        .listRowSeparator(.hidden, edges: .top)
                        .listRowSeparator(.visible, edges: .bottom)
                }
            }
        }
        .onAppear(perform: load)
    }
    
    private func load() {
        if recentlyUsedTags == nil {
            FireThread.readRecentlyUsedTags() { tags in
                self.recentlyUsedTags = tags
                self.isLoaded = true
            }
        }
    }
}
