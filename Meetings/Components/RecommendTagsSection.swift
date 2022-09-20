//
//  RecommendTagSection.swift
//  Meetings
//
//  Created by Yu on 2022/09/20.
//

import SwiftUI

struct RecommendTagsSection: View {
    
    private let words = ["雑談", "天神祭", "ゲーム", "休日", "初心者"]
    
    var body: some View {
        Section (header: Text("おすすめ")) {
            ForEach(words, id: \.self) { word in
                TagRow(word: word)
                    .listRowSeparator(.hidden, edges: .top)
                    .listRowSeparator(.visible, edges: .bottom)
            }
        }
    }
}
