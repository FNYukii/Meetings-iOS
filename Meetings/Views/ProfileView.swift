//
//  ProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            
            List {
                
                Section {
                    HStack {
                        Text("display_name")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Appleman")
                    }
                    
                    HStack {
                        Text("user_tag")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Apple-man-12")
                    }
                }
                
                Section {
                    NavigationLink(destination: AccountView()) {
                        Text("account_setting")
                    }
                }
                
            }

            .navigationTitle("profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("done")
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
}
