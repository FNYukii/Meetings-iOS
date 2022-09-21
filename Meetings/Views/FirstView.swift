//
//  FirstView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct FirstView: View {
    
    // States
    @ObservedObject private var signInStateViewModel = SignInStateViewModel()
    @ObservedObject private var threadsViewModel = ThreadsViewModel()
        
    // Navigations
    @State private var isShowCreateThreadView = false
    
    var body: some View {
        NavigationView {
            
            List {
                // Progress view
                if !threadsViewModel.isLoaded {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                }
                
                // Failed text
                if threadsViewModel.isLoaded && threadsViewModel.threads == nil {
                    Text("threads_reading_failed")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.secondary)
                        .listRowSeparator(.hidden)
                }
                
                // No content text
                if threadsViewModel.isLoaded && threadsViewModel.threads != nil && threadsViewModel.threads!.count == 0 {
                    Text("no_threads")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.secondary)
                        .listRowSeparator(.hidden)
                }
                
                // ThreadRows
                if threadsViewModel.threads != nil {
                    ForEach(threadsViewModel.threads!) { thread in
                        ThreadRow(thread: thread)
                    }
                    .listRowSeparator(.hidden, edges: .top)
                    .listRowSeparator(.visible, edges: .bottom)
                }
            }
            .listStyle(.plain)
            
            .sheet(isPresented: $isShowCreateThreadView) {
                CreateThreadView()
            }
            
            .navigationTitle("threads")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    SignInMenuOrProfileButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Add Thread Button
                    Button(action: {
                        isShowCreateThreadView.toggle()
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                    .disabled(!signInStateViewModel.isSignedIn)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
