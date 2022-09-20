//
//  SearchedThreadsGroup.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct SearchedThreadsGroup: View {
    
    @ObservedObject private var threadsViewModel = ThreadsByKeywordViewModel()
    
    init(keyword: String) {
        threadsViewModel.read(keyword: keyword)
    }
    
    var body: some View {
        Group {
            // Progress
            if !threadsViewModel.isLoaded {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }

            // Failed
            if threadsViewModel.isLoaded && threadsViewModel.threads == nil {
                Text("threads_reading_failed")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }

            // No content
            if threadsViewModel.isLoaded && threadsViewModel.threads != nil && threadsViewModel.threads!.count == 0 {
                Text("no_threads")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }

            // Done
            if threadsViewModel.isLoaded && threadsViewModel.threads != nil {
                ForEach(threadsViewModel.threads!) { thread in
                    ThreadRow(thread: thread)
                        .listRowSeparator(.hidden, edges: .top)
                        .listRowSeparator(.visible, edges: .bottom)
                }
            }
        }
    }
}
