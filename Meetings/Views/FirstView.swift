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
    
    // Navigation to any views
    @State private var isShowSignInView = false
    @State private var isShowSignUpView = false
    @State private var isShowCreateThreadView = false
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(threadsViewModel.threads) { thread in
                    ThreadRow(thread: thread)
                }
                .listRowSeparator(.hidden, edges: .top)
                .listRowSeparator(.visible, edges: .bottom)
            }
            .listStyle(PlainListStyle())
            
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
                    if signInStateViewModel.isSignedIn {
                        NavigationLink(destination: ProfileView(userId: FireAuth.uid()!)) {
                            Image(systemName: "person.crop.circle")
                                .font(.title2)
                        }
                    }
                    
                    if !signInStateViewModel.isSignedIn {
                        Menu {
                            Button(action: {
                                isShowSignInView.toggle()
                            }) {
                                Label("sign_in", systemImage: "")
                            }
                            
                            Button(action: {
                                isShowSignUpView.toggle()
                            }) {
                                Label("sign_up", systemImage: "")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.title3)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
