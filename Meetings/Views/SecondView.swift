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
    @State private var isSubmited = false
    
    var body: some View {
        NavigationView {
            SearchList(keyword: keyword, isSubmited: $isSubmited)
            
                .searchable(text: $keyword, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("keyword"))
                .onSubmit(of: .search) {
                    isSubmited = true
                }
            
                .navigationTitle("search")
                .navigationBarTitleDisplayMode(.inline)
            
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        ProfileButtonOrNot()
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}
