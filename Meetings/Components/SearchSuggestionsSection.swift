//
//  SearchSuggestionsSection.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct SearchSuggestionsSection: View {
    
    private let words = ["原神", "YouTube"]
    
    var body: some View {
        Section(header: Text("suggestions")) {
            ForEach(words, id: \.self) { word in
                Text(word)
                    .listRowSeparator(.hidden, edges: .top)
                    .listRowSeparator(.visible, edges: .bottom)
            }
        }
    }
}
