//
//  ThirdView.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct ThirdView: View {
    var body: some View {
        NavigationView {
            List {
//                // No Results
//                Text("no_notifications")
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .foregroundColor(.secondary)
//                    .listRowSeparator(.hidden)
                
                // Done
                NotificationRow()
                    .listRowSeparator(.hidden, edges: .top)
                    .listRowSeparator(.visible, edges: .bottom)
            }
            .listStyle(.plain)
            
            .navigationTitle("notifications")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    SignInMenuOrProfileButton()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
