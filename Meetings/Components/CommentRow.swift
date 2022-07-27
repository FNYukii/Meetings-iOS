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
    @State private var isLoadedUser = false
    
    @State private var likedUserIds: [String]? = nil
    @State private var isLoadedLikedUserIds = false
    
    @State private var thread: Thread? = nil
    @State private var isLoadedThread = false
    
    @State private var isShowDialog = false
        
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            
            // Icon Column
            Button (action: {
                isShowProfileView.toggle()
            }) {
                IconImage(url: user?.iconUrl, iconImageFamily: .medium)
            }
            .buttonStyle(.borderless)
            .disabled(isDisableShowingProfileView)
            
            // Detail Column
            VStack(alignment: .leading) {
                
                // Header Row
                HStack {
                    // Progress views
                    if !isLoadedUser {
                        Color.secondary
                            .opacity(0.2)
                            .frame(width: 80)
                        
                        Color.secondary
                            .opacity(0.2)
                            .frame(width: 80)
                    }
                    
                    // User reading failed views
                    if isLoadedUser && user == nil {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.secondary)
                        Text("user_reading_failed")
                            .foregroundColor(.secondary)
                    }
                    
                    // Display name & User tag
                    if isLoadedUser && user != nil {
                        Text(user!.displayName)
                            .fontWeight(.bold)
                        
                        Text("@\(user!.userTag)")
                            .foregroundColor(.secondary)
                    }
                    
                    // Date text
                    EditDate.howManyAgoText(from: comment.createdAt)
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
                
                // Text Row
                Text(comment.text)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Reaction Row
                HStack {
                    // Progress view
                    if !isLoadedLikedUserIds {
                        Color.secondary
                            .opacity(0.2)
                            .frame(width: 40)
                    }
                    
                    // Reading failed view
                    if isLoadedLikedUserIds && likedUserIds == nil {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.secondary)
                        Text("likes_reading_failed")
                            .foregroundColor(.secondary)
                    }
                    
                    // Like button when not liked
                    if isLoadedLikedUserIds && likedUserIds != nil && !likedUserIds!.contains(FireAuth.uid() ?? "") {
                        Button(action: {
                            FireUser.likeComment(commentId: comment.id)
                            loadLikedUserIds()
                        }) {
                            HStack(spacing: 2) {
                                Image(systemName: "heart")
                                Text("\(likedUserIds!.count)")
                            }
                            .foregroundColor(.secondary)
                        }
                        .buttonStyle(.borderless)
                        .disabled(!FireAuth.isSignedIn())
                    }
                    
                    // Like button when liked
                    if isLoadedLikedUserIds && likedUserIds != nil && likedUserIds!.contains(FireAuth.uid() ?? "") {
                        Button(action: {
                            FireUser.unlikeComment(commentId: comment.id)
                            loadLikedUserIds()
                        }) {
                            HStack(spacing: 2) {
                                Image(systemName: "heart.fill")
                                Text("\(likedUserIds!.count)")
                            }
                            .foregroundColor(.red)
                        }
                        .buttonStyle(.borderless)
                        .disabled(!FireAuth.isSignedIn())
                    }
                }
                .frame(height: 16)
                .padding(.top, 4)
                
                // Thread Title Row
                Group {
                    // Progress view
                    if isAbleShowingThreadView && !isLoadedThread {
                        Color.secondary
                            .opacity(0.2)
                            .frame(width: 120, height: 16)
                    }
                    
                    // Not found text
                    if isAbleShowingThreadView && isLoadedThread && thread == nil {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text("thread_not_found")
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    // Thread title
                    if isAbleShowingThreadView && isLoadedThread && thread != nil {
                        Button(action: {
                            isShowThreadView.toggle()
                        }) {
                            Text(thread!.title)
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
        }
        .background(
            Group {
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
        )
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
                self.isLoadedUser = true
            }
        }
        
        // Commentが追加されたThreadを読み取り
        if isAbleShowingThreadView && thread == nil {
            FireThread.readThread(threadId: comment.threadId) { thread in
                self.thread = thread
                self.isLoadedThread = true
            }
        }
        
        // コメントをいいねしたユーザーを読み取り
        if likedUserIds == nil {
            loadLikedUserIds()
        }
    }
    
    private func loadLikedUserIds() {
        FireUser.readLikedUserIds(commentId: comment.id) { userIds in
            withAnimation {
                self.likedUserIds = userIds
                self.isLoadedLikedUserIds = true
            }
        }
    }
}
