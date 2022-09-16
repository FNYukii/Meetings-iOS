//
//  FirstView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct FirstView: View {
    
    // States
    @ObservedObject private var threadsViewModel = ThreadsViewModel()
    @ObservedObject private var signInStateViewModel = SignInStateViewModel()
        
    // Navigations
    @State private var isShowSignInView = false
    @State private var isShowSignUpView = false
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
                
                // No content text
                if threadsViewModel.isLoaded && threadsViewModel.threads.count == 0 {
                    Text("no_threads")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.secondary)
                        .listRowSeparator(.hidden)
                }
                
                // ThreadRows
                ForEach(threadsViewModel.threads) { thread in
                    ThreadRow(thread: thread)
                }
                .listRowSeparator(.hidden, edges: .top)
                .listRowSeparator(.visible, edges: .bottom)
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
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                    .disabled(!signInStateViewModel.isSignedIn)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
