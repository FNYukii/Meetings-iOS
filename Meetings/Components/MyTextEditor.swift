//
//  MyTextEditor.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI
import Introspect

struct MyTextEditor: View {
    
    let hintText: Text
    @Binding var text: String
    let isFocus: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .frame(minHeight: 130)
                .introspectTextView { textEditor in
                    if isFocus {
                        textEditor.becomeFirstResponder()
                    }
                }
            
            hintText
                .foregroundColor(Color(UIColor.placeholderText))
                .opacity(text.isEmpty ? 1 : 0)
                .padding(.top, 8)
                .padding(.leading, 5)
        }
        .padding(.leading, -6)
    }
}
