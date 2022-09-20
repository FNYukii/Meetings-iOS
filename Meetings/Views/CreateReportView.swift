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
    let targetId: String
    let targetFamily: ReportTargetFamily
    let navTitle: String
    
    // Categories
    private let probremCategories = ["violent", "spam", "sensitive", "fake"]
    
    // States
    @State private var probremCategorySelection = 0
    @State private var detail = ""
        
    // Loading, Dialog
    @State private var isLoading = false
    @State private var isShowDialogError = false
    
    init(targetId: String, targetFamily: ReportTargetFamily) {
        self.targetId = targetId
        self.targetFamily = targetFamily
        
        if targetFamily == .user {
            self.navTitle = NSLocalizedString("report_user", comment: "")
        } else if targetFamily == .thread {
            self.navTitle = NSLocalizedString("report_thread", comment: "")
        } else {
            self.navTitle = NSLocalizedString("report_comment", comment: "")
        }
    }
        
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("category")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Picker("category", selection: $probremCategorySelection) {
                            ForEach(0 ..< probremCategories.count, id: \.self) { index in
                                Text(probremCategories[index])
                                    .tag(index)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                Section {
                    GuidedTextEditor(hintText: Text("detail"), text: $detail, isFocus: false)
                }
            }
            
            .alert("failed", isPresented: $isShowDialogError) {
                Button("ok") {
                    isShowDialogError = false
                }
            } message: {
                Text("report_creation_failed")
            }
            
            .navigationTitle(navTitle)
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
                            FireReport.createReport(targetId: targetId, targetFamily: targetFamily.rawValue, probremCategory: probremCategories[probremCategorySelection], detail: detail) { documentId in
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
                            Text("submit")
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
