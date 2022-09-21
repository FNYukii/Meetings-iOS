//
//  PopularThreadsSection.swift
//  Meetings
//
//  Created by Yu on 2022/09/22.
//

import SwiftUI

struct RecentlyCommentedThreadsSection: View {
    
    @State private var threads: [Thread]? = nil
    @State private var isLoadedThreads = false
    
    var body: some View {
        Section(header: Text("人気")) {
            // Progress
            if !isLoadedThreads {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }
            
            // Failed
            if isLoadedThreads && threads == nil {
                Text("threads_reading_failed")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // No Results
            if isLoadedThreads && threads != nil && threads!.count == 0 {
                Text("no_threads")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // Done
            if threads != nil {
                ForEach(threads!) { thread in
                    ThreadRow(thread: thread)
                }
                .listRowSeparator(.hidden, edges: .top)
                .listRowSeparator(.visible, edges: .bottom)
            }
        }
        .onAppear(perform: load)
    }
    
    private func load() {
        if threads == nil {
            FireThread.readThreadsByCommentedAt() {threads in
                self.threads = threads
                self.isLoadedThreads = true
            }
        }
    }
}
