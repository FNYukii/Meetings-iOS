//
//  CreateReportView.swift
//  Meetings
//
//  Created by Yu on 2022/07/28.
//

import SwiftUI

struct CreateReportView: View {
    
    // Enviorosments
    @Environment(\.dismiss) private var dismiss
    
    // States
    @State private var category = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("category", text: $category)
            }
            
            .navigationTitle("report_thread")
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
