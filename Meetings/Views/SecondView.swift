//
//  SecondView.swift
//  Meetings
//
//  Created by Yu on 2022/09/20.
//

import SwiftUI

struct SecondView: View {
    
    // States
    @State private var keyword = ""
    @State private var isShowResultView = false
        
    var body: some View {
        NavigationView {
            List {
                
                // Recommended Tags Section
                if keyword.isEmpty {
                    RecommendTagSection()
                }
            }
            .listStyle(.plain)
            
            .background(
                NavigationLink(destination: ResultView(keyword: keyword), isActive: $isShowResultView) {
                    EmptyView()
                }
                .hidden()
            )
            
            .searchable(text: $keyword, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("keyword"))
            .onSubmit(of: .search) {
                isShowResultView.toggle()
            }
            
            .navigationTitle("search")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    ProfileButtonOrNot()
                }
            }
        }
    }
}
