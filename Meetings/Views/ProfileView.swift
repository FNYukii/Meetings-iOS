//
//  ProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct ProfileView: View {
    
    let userId: String
    
    @State private var isShowAccountView = false
    
    var body: some View {
        List {
            // Header
            HStack(alignment: .top) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading) {
                    Text("Ayaka")
                        .fontWeight(.bold)
                    
                    Text("AyakaSan12")
                        .foregroundColor(.secondary)
                }
            }
            .listRowSeparator(.hidden, edges: .all)
            
            // Introduction
            Text("Hello. My beautiful world.")
                .listRowSeparator(.hidden, edges: .all)
        }
        .listStyle(.plain)
        
        .sheet(isPresented: $isShowAccountView) {
            AccountView()
        }
        
        .navigationTitle("profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if FireAuth.uid() == userId {
                        Button(action: {
                            
                        }) {
                            Label("edit_profile", systemImage: "person")
                        }
                        
                        Button(action: {
                            isShowAccountView.toggle()
                        }) {
                            Label("account_setting", systemImage: "person")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
    
    
}
