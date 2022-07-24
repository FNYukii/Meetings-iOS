//
//  ProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct ProfileView: View {
    
    let userId: String
    
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
        
        .navigationTitle("profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    
                }) {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                }
            }
        }
    }
    
    
}
