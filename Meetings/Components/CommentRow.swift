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
        HStack(alignment: .top) {
            
            // Icon
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                
                // Header
                HStack {
                    Text("Ayaka")
                        .fontWeight(.bold)
                    
                    Text("AyakaSan12")
                        .foregroundColor(.secondary)
                    
                    EditDate.HowManyAgoText(from: comment.createdAt)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Menu {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                            .padding(.vertical, 6)
                    }
                }
                
                // Text
                Text(comment.text)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Reaction Bar
                HStack {
                    Button(action: {
                        print("HELLO! Like")
                    }) {
                        HStack {
                            Image(systemName: "heart")
                            Text("4")
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 4)
            }
        }
    }
}
