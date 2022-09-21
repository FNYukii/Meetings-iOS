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
        
    // Navigations
    @State private var isShowCreateThreadView = false
    
    var body: some View {
        NavigationView {
            
            List {
                // Popular Threads
                RecentlyCommentedThreadsSection()
                
                // Recent Threads
                RecentlyCreatedThreadsSection()
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
