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
    @Binding var keyword: String
    @Binding var isSubmited: Bool
        
    var body: some View {
        List {
            // 非検索時
            if !isSearching {
                LatestCommentWithImageSection()
                RecentlyUsedTagsSection(keyword: $keyword)
            }
            
            // 検索途中キーワードなし
            else if isSearching && !isSubmited && keyword.isEmpty {
                SearchHistorySection(keyword: $keyword)
            }
            
            // 検索途中キーワードあり
            else if isSearching && !isSubmited && !keyword.isEmpty {
                SearchSuggestionsSection()
            }
            
            // 検索キーワード送信後
            else if isSearching && isSubmited {
                SearchResultsSection(keyword: keyword)
            }
        }
        .listStyle(.plain)
        .animation(.none, value: isSearching)
        .animation(.none, value: keyword)
        
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
