//
//  MyTextEditor.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct MyTextEditor: View {
    
    let hintText: Text
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .frame(minHeight: 130)
            
            hintText
                .foregroundColor(Color(UIColor.placeholderText))
                .opacity(text.isEmpty ? 1 : 0)
                .padding(.top, 8)
                .padding(.leading, 5)
        }
        .padding(.leading, -6)
    }
}
