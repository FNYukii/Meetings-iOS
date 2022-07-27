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
    
    var body: some View {
        NavigationView {
            
            Form {
                Text("HELLO")
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
