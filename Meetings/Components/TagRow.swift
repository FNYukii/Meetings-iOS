//
//  TagRow.swift
//  Meetings
//
//  Created by Yu on 2022/09/20.
//

import SwiftUI

struct TagRow: View {
        
    // Word
    let word: String
    
    // States
    @State private var numberOfThread: Int? = nil
    @State private var isLoaded = false
    
    @Binding var keyword: String
    
    var body: some View {
        
        Button(action: {
            keyword = word
        }) {
            VStack(alignment: .leading) {
                // Header Row
                HStack {
                    // Name Column
                    Text(word)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Menu Column
                    Menu {
                        Button(action: {
                            
                        }) {
                            Text("興味なし")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                            .padding(.vertical, 6)
                    }
                }
                
                // Thread Count Row
                HStack {
                    // Progress
                    if !isLoaded {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    
                    // Failed
                    if isLoaded && numberOfThread == nil {
                        Image(systemName: "exclamationmark.triangle")
                    }
                    
                    // Done
                    if isLoaded && numberOfThread != nil {
                        Text("\(numberOfThread!)")
                            .foregroundColor(.secondary)
                    }
                }
                .foregroundColor(.secondary)
            }
        }
        .onAppear(perform: load)
    }
    
    private func load() {
        if numberOfThread == nil {
            FireThread.readNumberOfThreadByTag(tag: word) { number in
                self.numberOfThread = number
                self.isLoaded = true
            }
        }
    }
}
