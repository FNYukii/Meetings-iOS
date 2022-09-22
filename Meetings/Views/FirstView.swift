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
    @State private var isSortByCreatedAt = UserDefaults.standard.bool(forKey: "isSortByCreatedAt")
        
    // Navigations
    @State private var isShowCreateThreadView = false
    
    var body: some View {
        NavigationView {
            
            ZStack {
                // List Layer
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
                
                // FAB Layer
                if signInStateViewModel.isSignedIn {
                    FloatingActionButton(systemImage: "plus", action: {
                        isShowCreateThreadView.toggle()
                    })
                }
            }
            
            .sheet(isPresented: $isShowCreateThreadView) {
                CreateThreadView()
            }
            
            .navigationTitle("home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    SignInMenuOrProfileButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Sort Menu
                    Menu {
                        Button(action: {
                            isSortByCreatedAt = true
                            UserDefaults.standard.set(true, forKey: "isSortByCreatedAt")
                        }) {
                            Label("creation_order", systemImage: isSortByCreatedAt ? "checkmark" : "")
                        }
                        
                        Button(action: {
                            isSortByCreatedAt = false
                            UserDefaults.standard.set(false, forKey: "isSortByCreatedAt")
                        }) {
                            Label("recently_commented_order", systemImage: isSortByCreatedAt ? "" : "checkmark")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
