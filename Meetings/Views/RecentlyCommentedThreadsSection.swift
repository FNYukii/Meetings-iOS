//
//  PopularThreadsSection.swift
//  Meetings
//
//  Created by Yu on 2022/09/22.
//

import SwiftUI

struct RecentlyCommentedThreadsSection: View {
    
    @ObservedObject private var threadsViewModel = ThreadsByCommentedAtViewModel()
    
    var body: some View {
        Section(header: Text("コメントが追加された順")) {
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
            
            // No Results
            if threadsViewModel.isLoaded && threadsViewModel.threads != nil && threadsViewModel.threads!.count == 0 {
                Text("no_threads")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // Done
            if threadsViewModel.threads != nil {
                ForEach(threadsViewModel.threads!) { thread in
                    ThreadRow(thread: thread)
                }
                .listRowSeparator(.hidden, edges: .top)
                .listRowSeparator(.visible, edges: .bottom)
            }
        }
    }
}
