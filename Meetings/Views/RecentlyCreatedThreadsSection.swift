//
//  RecentThreadsSection.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct RecentlyCreatedThreadsSection: View {
    
    @ObservedObject private var threadsViewModel = ThreadsByCreatedAtViewModel()
    
    var body: some View {
        Section(header: Text("最近")) {
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
