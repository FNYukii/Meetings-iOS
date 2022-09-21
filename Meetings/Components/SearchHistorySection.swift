//
//  SearchHistorySection.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct SearchHistorySection: View {
    
    private let words = UserDefaults.standard.stringArray(forKey: "searchedWords") ?? []
    
    var body: some View {
        Section(header: Text("検索履歴")) {
            ForEach(words, id: \.self) { word in
                Button( action: {
                    
                }) {
                    Text(word)
                }
                .listRowSeparator(.hidden, edges: .top)
                .listRowSeparator(.visible, edges: .bottom)
            }
        }
    }
}
