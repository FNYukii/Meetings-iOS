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
            if isSearching && !isSubmited && keyword.isEmpty {
                Section(header: Text("履歴")) {
                    
                }
            }
            
            // Search Suggestions Section
            if isSearching && !isSubmited && !keyword.isEmpty {
                Section(header: Text("候補")) {
                    
                }
            }
            
            // Search Results Section
            if isSubmited {
                SearchResultsSection()
            }
        }
        .listStyle(.plain)
        
        // isSearchingがfalseになったら、isSubmitedもfalseにする
        .onChange(of: isSearching) { newValue in
            if !newValue {
                isSubmited = false
            }
        }
        
        // keywordが変更されたら、isSubmitedをfalseにする
        .onChange(of: keyword) { _ in
            isSubmited = false
        }
    }
}
