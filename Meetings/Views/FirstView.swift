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
                RecentlyCommentedThreadsSection()                
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
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Sort Menu
                    Menu {
                        Button(action: {
                            
                        }) {
                            Label("作成された日時", systemImage: "square.and.pencil")
                        }
                        
                        Button(action: {
                            
                        }) {
                            Label("コメントされた日時", systemImage: "bubble.right")
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
