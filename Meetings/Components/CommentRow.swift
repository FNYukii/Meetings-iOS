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
    
    // Navigations
    let isDisableShowingProfileView: Bool
    @State private var isShowProfileView = false
    let isAbleShowingThreadView: Bool
    @State private var isShowThreadView = false
    
    // States
    @State private var user: User? = nil
    @State private var likedUserIds: [String]? = nil
    @State private var thread: Thread? = nil
    @State private var isShowDialog = false
        
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            
            // Icon Column
            Button (action: {
                isShowProfileView.toggle()
            }) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.secondary)
                    .opacity(0.5)
            }
            .buttonStyle(.borderless)
            .disabled(isDisableShowingProfileView)
            
            // Detail Column
            VStack(alignment: .leading, spacing: 4) {
                
                // Header Row
                HStack {
                    // 3 Progress view
                    if user == nil {
                        Color.secondary.opacity(0.2)
                            .frame(width: 80)
                        
                        Color.secondary.opacity(0.2)
                            .frame(width: 80)
                        
                        Color.secondary.opacity(0.2)
                            .frame(width: 40)
                    }
                    
                    // Display name & User tag & HowManyAgoText
                    if user != nil {
                        Text(user!.displayName)
                            .fontWeight(.bold)
                        
                        Text(user!.userTag)
                            .foregroundColor(.secondary)
                        
                        EditDate.HowManyAgoText(from: comment.createdAt)
                            .foregroundColor(.secondary)
                    }
                    
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
                
                // Text Row
                Group {
                    // Progress view
                    if user == nil {
                        Color.secondary.opacity(0.2)
                            .frame(width: 200, height: 16)
                    }
                    
                    // Text
                    if user != nil {
                        Text(comment.text)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                // Reaction Row
                HStack {
                    // Progress view
                    if likedUserIds == nil {
                        Color.secondary.opacity(0.2)
                            .frame(width: 40, height: 16)
                    }
                    
                    // Like button
                    if likedUserIds != nil {
                        Button(action: {
                            // Like
                            if FireAuth.isSignedIn() && !likedUserIds!.contains(FireAuth.uid()!) {
                                FireUser.likeComment(commentId: comment.id)
                            }
                            
                            // Unlike
                            if FireAuth.isSignedIn() && likedUserIds!.contains(FireAuth.uid()! ) {
                                FireUser.unlikeComment(commentId: comment.id)
                            }
                        }) {
                            HStack(spacing: 2) {
                                Image(systemName: FireAuth.isSignedIn() && likedUserIds!.contains(FireAuth.uid()!) ? "heart.fill" : "heart")
                                Text("\(likedUserIds!.count)")
                            }
                            .foregroundColor(FireAuth.isSignedIn() && likedUserIds!.contains(FireAuth.uid()!) ? .red : .secondary)
                        }
                        .buttonStyle(.borderless)
                        .disabled(!FireAuth.isSignedIn())
                    }
                }
                .padding(.top, 4)
                
                // Thread Title Row
                Group {
                    // Progress view
                    if isAbleShowingThreadView && thread == nil {
                        Color.secondary.opacity(0.2)
                            .frame(width: 120, height: 16)
                    }
                    
                    // Thread title
                    if isAbleShowingThreadView && thread != nil {
                        Button(action: {
                            isShowThreadView.toggle()
                        }) {
                            Text(thread!.title)
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                
                // NavigationLink to ProfileView
                NavigationLink(destination: ProfileView(userId: comment.userId), isActive: $isShowProfileView) {
                    EmptyView()
                }
                .hidden()
                
                // NavigationLink to ThreadView
                if thread != nil {
                    NavigationLink(destination: ThreadView(thread: thread!), isActive: $isShowThreadView) {
                        EmptyView()
                    }
                    .hidden()
                }
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
        if isAbleShowingThreadView && thread == nil {
            FireThread.readThread(threadId: comment.threadId) { thread in
                self.thread = thread
            }
        }
        
        // コメントをいいねしたユーザーを読み取り
        if likedUserIds == nil {
            FireUser.readLikedUserIds(commentId: comment.id) { userIds in
                self.likedUserIds = userIds
            }
        }
    }
}
