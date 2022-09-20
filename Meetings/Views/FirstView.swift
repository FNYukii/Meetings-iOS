//
//  FirstView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct FirstView: View {
    
    // States
//    @ObservedObject private var threadsViewModel = ThreadsViewModel()
    @ObservedObject private var signInStateViewModel = SignInStateViewModel()
    @ObservedObject private var threadsViewModel = ThreadsByKeywordViewModel(keyword: "")
        
    // Navigations
    @State private var isShowSignInView = false
    @State private var isShowSignUpView = false
    @State private var isShowCreateThreadView = false
    
    // SearchBar
    @ObservedObject var searchBar: SearchBar = SearchBar()
    
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
            
            .sheet(isPresented: $isShowSignInView) {
                SignInView()
            }
            
            .sheet(isPresented: $isShowSignUpView) {
                SignUpView()
            }
            
            .sheet(isPresented: $isShowCreateThreadView) {
                CreateThreadView()
            }
            
            // SearchBar
            .add(self.searchBar)
            .onChange(of: self.searchBar.text) { _ in
                
            }
            
            .navigationTitle("threads")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    // Profile Button
                    if signInStateViewModel.isSignedIn {
                        NavigationLink(destination: ProfileView(userId: FireAuth.uid()!)) {
                            UserIconImage(userId: FireAuth.uid(), iconImageFamily: .small)
                        }
                    }
                    
                    // Sign In Menu
                    if !signInStateViewModel.isSignedIn {
                        Menu {
                            Button(action: {
                                isShowSignInView.toggle()
                            }) {
                                Label("sign_in", systemImage: "ipad.and.arrow.forward")
                            }
                            
                            Button(action: {
                                isShowSignUpView.toggle()
                            }) {
                                Label("sign_up", systemImage: "square.and.pencil")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.title3)
                        }
                    }
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
