//
//  EditProfileView.swift
//  Meetings
//
//  Created by Yu on 2022/07/27.
//

import SwiftUI

struct EditProfileView: View {
    
    // Environments
    @Environment(\.dismiss) private var dismiss
    
    // States
    @State private var displayName = ""
    @State private var userTag = ""
    @State private var introduction = ""
    @State private var icon: UIImage? = nil
    
    var body: some View {
        NavigationView {
            
            Form {
                Section {
                    TextField("display_name", text: $displayName)
                    TextField("user_tag", text: $userTag)
                }
                
                Section {
                    MyTextEditor(hintText: Text("introduction"), text: $introduction)
                }
            }
            
            .navigationTitle("edit_profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                
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
        .navigationViewStyle(.stack)
    }
}
