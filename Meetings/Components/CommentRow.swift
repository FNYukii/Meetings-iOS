//
//  CommentRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct CommentRow: View {
    
    let comment: Comment
    
    @State private var user: User? = nil
    
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
                    
                    if user == nil {
                        Color.secondary.opacity(0.2)
                            .frame(width: 80)
                        
                        Color.secondary.opacity(0.2)
                            .frame(width: 80)
                    }
                    
                    if user != nil {
                        Text(user!.displayName)
                            .fontWeight(.bold)
                        
                        Text(user!.userTag)
                            .foregroundColor(.secondary)
                    }
                    
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
                        HStack(spacing: 2) {
                            Image(systemName: "heart")
                            Text("0")
                        }
                        .foregroundColor(.secondary)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.top, 4)
            }
        }
        .onAppear(perform: load)
    }
    
    private func load() {
        // Commentを追加したUserを読み取り
        if user == nil {
            FireUser.readUser(userId: comment.userId) { user in
                self.user = user
            }
        }
    }
}
