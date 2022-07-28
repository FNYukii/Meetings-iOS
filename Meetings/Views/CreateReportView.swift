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
    
    // Report target
    let target: ReportTargetFamily
    
    // States
    @State private var category = ""
    @State private var detail = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("category", text: $category)
                }
                
                Section {
                    MyTextEditor(hintText: Text("detail"), text: $detail)
                }
            }
            
            .navigationTitle("report_\(target.rawValue)")
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

enum ReportTargetFamily: String {
    case thread = "thread"
    case comment = "comment"
}
