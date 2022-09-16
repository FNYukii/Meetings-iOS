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
    
    // Categories
    let categories = ["violent", "spam", "sensitive", "fake"]
    
    // States
    @State private var categorySelection = 0
    @State private var detail = ""
    
    // Loading, Dialog
    @State private var isLoading = false
    @State private var isShowDialogError = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("category")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Picker("category", selection: $categorySelection) {
                            ForEach(0 ..< categories.count, id: \.self) { index in
                                Text(categories[index])
                                    .tag(index)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                Section {
                    MyTextEditor(hintText: Text("detail"), text: $detail, isFocus: false)
                }
            }
            
            .alert("failed", isPresented: $isShowDialogError) {
                Button("ok") {
                    isShowDialogError = false
                }
            } message: {
                Text("report_creation_failed")
            }
            
            .navigationTitle("report_\(target.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Create Button
                    if !isLoading {
                        Button(action: {
                            isLoading = true
                            FireReport.createReport(target: target.rawValue, category: categories[categorySelection], detail: detail) { documentId in
                                // 失敗
                                if documentId == nil {
                                    isLoading = false
                                    isShowDialogError = true
                                    return
                                }
                                
                                // 成功
                                dismiss()
                            }
                        }) {
                            Text("report")
                                .fontWeight(.bold)
                        }
                        .disabled(isLoading)
                    }
                    
                    // ProgressView
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
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
    case user = "user"
}
