//
//  SearchHistorySection.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct SearchHistorySection: View {
    
    // States
    @State private var searchedWords = UserDefaults.standard.stringArray(forKey: "searchedWords") ?? []
    @Binding var keyword: String
    
    var body: some View {
        Section(header: Text("検索履歴")) {
            ForEach(searchedWords, id: \.self) { word in
                Button( action: {
                    keyword = word
                }) {
                    Text(word)
                }
                .listRowSeparator(.hidden, edges: .top)
                .listRowSeparator(.visible, edges: .bottom)
                
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(action: {
                        // 単語を削除
                        withAnimation {
                            searchedWords.removeAll(where: {$0 == word})
                        }
                        UserDefaults.standard.set(searchedWords, forKey: "searchedWords")
                    }) {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
        }
    }
}
