//
//  CommentRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import SwiftUI

struct CommentRow: View {
    
    // Comment to show
    let comment: Comment
    
    // Navigation
    let isDisableShowingProfileView: Bool
    @State private var isShowProfileView = false
    
    // States
//    let isShowThreadTitle: Bool
    @State private var user: User? = nil
    @State private var thread: Thread? = nil
    @State private var isShowDialog = false
        
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            
            // Icon
            Button (action: {
                isShowProfileView.toggle()
            }) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.borderless)
            .disabled(isDisableShowingProfileView)
            
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
                        if FireAuth.uid() == comment.userId {
                            Button(role: .destructive) {
                                isShowDialog.toggle()
                            } label: {
                                Label("delete_comment", systemImage: "trash")
                            }
                        }
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
                    .buttonStyle(.borderless)
                }
                .padding(.top, 4)
                
                NavigationLink(destination: ProfileView(userId: comment.userId), isActive: $isShowProfileView) {
                    EmptyView()
                }
                .hidden()
                
            }
        }
        .onAppear(perform: load)
        
        .confirmationDialog("", isPresented: $isShowDialog, titleVisibility: .hidden) {
            Button("delete_comment", role: .destructive) {
                FireComment.deleteComment(commentId: comment.id)
            }
        } message: {
            Text("are_you_sure_you_want_to_delete_this_comment")
        }
    }
    
    private func load() {
        // Commentを追加したUserを読み取り
        if user == nil {
            FireUser.readUser(userId: comment.userId) { user in
                self.user = user
            }
        }
        
        // Commentが追加されたThreadを読み取り
//        if isShowThreadTitle && thread == nil {
//            
//        }
    }
}
