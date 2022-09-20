//
//  RecommendTagSection.swift
//  Meetings
//
//  Created by Yu on 2022/09/20.
//

import SwiftUI

struct RecommendTagSection: View {
    
    private let recommendedTags = ["雑談", "天神祭", "ゲーム", "休日", "初心者"]
    
    var body: some View {
        Section (header: Text("おすすめ")) {
            ForEach(recommendedTags, id: \.self) { tag in
                TagRow(name: tag)
                    .listRowSeparator(.hidden, edges: .top)
                    .listRowSeparator(.visible, edges: .bottom)
            }
        }
    }
}
