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
    @State private var isSortByCreatedAt = true
        
    // Navigations
    @State private var isShowCreateThreadView = false
    
    var body: some View {
        NavigationView {
            
            List {
                // Recently Created Threads
                if isSortByCreatedAt {
                    RecentlyCreatedThreadsSection()
                }
                
                // Recently Commented Threads
                if !isSortByCreatedAt {
                    RecentlyCommentedThreadsSection()
                }
            }
            .listStyle(.plain)
            
            .sheet(isPresented: $isShowCreateThreadView) {
                CreateThreadView()
            }
            
            .navigationTitle("home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    SignInMenuOrProfileButton()
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Sort Menu
                    Menu {
                        Button(action: {
                            isSortByCreatedAt = true
                        }) {
                            Label("creation_order", systemImage: isSortByCreatedAt ? "checkmark" : "")
                        }
                        
                        Button(action: {
                            isSortByCreatedAt = false
                        }) {
                            Label("recently_commented_order", systemImage: isSortByCreatedAt ? "" : "checkmark")
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    
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
