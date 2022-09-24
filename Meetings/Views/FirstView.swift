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
    @State private var sortSelection = UserDefaults.standard.integer(forKey: "sortSelection")
    
    // Navigations
    @State private var isShowCreateThreadView = false
    
    var body: some View {
        NavigationView {
            
            ZStack {
                // List Layer
                List {
                    // Recently Created Threads
                    if sortSelection == 0 {
                        RecentlyCreatedThreadsSection()
                    }
                    
                    // Recently Commented Threads
                    if sortSelection == 1 {
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
            
            .onChange(of: sortSelection) { newValue in
                UserDefaults.standard.set(newValue, forKey: "sortSelection")
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
                        Picker(selection: $sortSelection, label: Text("")) {
                            Text("creation_order")
                                .tag(0)
                            
                            Text("recently_commented_order")
                                .tag(1)
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
