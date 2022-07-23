//
//  CommentRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct CommentRow: View {
    
    let comment: Comment
    
    var body: some View {
        HStack {
            
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Ayaka")
                        .fontWeight(.bold)
                    
                    Text("AyakaSan12")
                        .foregroundColor(.secondary)
                    
                    Text("12h")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Menu {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                            .padding(.vertical, 6)
                    }
                }
                
                Text(comment.text)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
