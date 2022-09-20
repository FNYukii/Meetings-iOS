//
//  SearchList.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct SearchList: View {
    
    // Environments
    @Environment(\.isSearching) var isSearching
    
    // States
    let keyword: String
    @Binding var isSubmited: Bool
        
    var body: some View {
        List {
            // Recommend Tags Section
            if !isSearching {
                RecommendTagsSection()
            }
            
            // Search History Section
            
            // Search Suggestions Section
            
            // Search Results Section
            if isSubmited {
                SearchResultsSection()
            }
        }
        .listStyle(.plain)
        
        .onChange(of: isSearching) { newValue in
            print("isSearching: \(isSearching) to \(newValue)")
            
            if !newValue {
                isSubmited = false
            }
        }
    }
}
