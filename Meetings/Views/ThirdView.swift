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
                Text("no_notifications")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
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
