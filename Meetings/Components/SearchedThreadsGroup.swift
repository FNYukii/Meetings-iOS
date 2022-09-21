//
//  SearchedThreadsGroup.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct SearchedThreadsGroup: View {
    
    let keyword: String
    
    @State private var threads: [Thread]? = nil
    @State private var isLoaded = false
    
    var body: some View {
        Group {
            // Progress
            if !isLoadedThreads {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }

            // Failed
            if isLoaded && threads == nil {
                Text("reading_failed")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }

            // No Results
            if isLoaded && threads != nil && threads!.count == 0 {
                Text("no_results")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }

            // Done
            if isLoaded && threads != nil {
                ForEach(threads!) { thread in
                    ThreadRow(thread: thread)
                        .listRowSeparator(.hidden, edges: .top)
                        .listRowSeparator(.visible, edges: .bottom)
                }
            }
        }
        .onAppear(perform: load)
    }
    
    private func load() {
        if threads == nil {
            FireThread.readThreads(keyword: keyword) { threads in
                self.threads = threads
                self.isLoaded = true
            }
        }
    }
}
