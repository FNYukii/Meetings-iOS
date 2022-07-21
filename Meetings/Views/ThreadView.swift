//
//  ThreadView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct ThreadView: View {
    
    @State private var isShowCreateCommentView = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
            .sheet(isPresented: $isShowCreateCommentView) {
                CreateCommentView()
            }
            
            .navigationTitle("hello")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowCreateCommentView.toggle()
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        
    }
}
