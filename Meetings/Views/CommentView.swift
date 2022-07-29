//
//  CommentView.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI

struct CommentView: View {
    
    // Comment to show
    let comment: Comment
    
    // Navigations
    @State private var isShowProfileView = false
    @State private var isShowThreadView = false
    @State private var isShowCreateReportView = false
    
    // States
    @State private var user: User? = nil
    @State private var isLoadedUser = false
    
    @State private var likedUserIds: [String]? = nil
    @State private var isLoadedLikedUserIds = false
    
    @State private var thread: Thread? = nil
    @State private var isLoadedThread = false
    
    // Dialog
    @State private var isShowDialogDelete = false
    
    var body: some View {
        
        List {
            
            VStack(alignment: .leading) {
                
                // Header Row
                HStack(alignment: .top) {
                    // Icon Column
                    Button (action: {
                        isShowProfileView.toggle()
                    }) {
                        UserIconImage(userId: comment.userId, iconImageFamily: .medium)
                    }
                    .buttonStyle(.borderless)
                    
                    // Detail Column
                    VStack(alignment: .leading) {
                        // Progress views Row
                        if !isLoadedUser {
                            Color.secondary
                                .opacity(0.2)
                                .frame(width: 80)
                            
                            Color.secondary
                                .opacity(0.2)
                                .frame(width: 80)
                        }
                        
                        // User reading failed views Row
                        if isLoadedUser && user == nil {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.secondary)
                            Text("user_reading_failed")
                                .foregroundColor(.secondary)
                        }
                        
                        // Display name & User tag Row
                        if isLoadedUser && user != nil {
                            Text(user!.displayName)
                                .fontWeight(.bold)
                            
                            Text("@\(user!.userTag)")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Menu Column
                    Menu {
                        // 削除ボタン
                        if FireAuth.uid() == comment.userId {
                            Button(role: .destructive) {
                                isShowDialogDelete.toggle()
                            } label: {
                                Label("delete_comment", systemImage: "trash")
                            }
                        }
                        
                        // 報告ボタン
                        if FireAuth.uid() != comment.userId {
                            Button(action: {
                                isShowCreateReportView.toggle()
                            }) {
                                Label("report_comment", systemImage: "flag")
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
                
                // Images Row
                Group {
                    if comment.imageUrls.count == 1 {
                        CommentImage(url: comment.imageUrls.first)
                    }
                    
                    if comment.imageUrls.count == 2 {
                        HStack {
                            CommentImage(url: comment.imageUrls.first)
                            CommentImage(url: comment.imageUrls[1])
                        }
                    }
                    
                    if comment.imageUrls.count == 3 {
                        HStack {
                            CommentImage(url: comment.imageUrls.first)
                            CommentImage(url: comment.imageUrls[1])
                        }
                        
                        CommentImage(url: comment.imageUrls[2])
                    }
                    
                    if comment.imageUrls.count == 4 {
                        HStack {
                            CommentImage(url: comment.imageUrls.first)
                            CommentImage(url: comment.imageUrls[1])
                        }
                        
                        HStack {
                            CommentImage(url: comment.imageUrls[2])
                            CommentImage(url: comment.imageUrls[3])
                        }
                    }
                }
                
                // Date Row
                Text("2022-1-1")
                    .foregroundColor(.secondary)
                
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
                
                // Thread Title Row
                Group {
                    // Progress view
                    if !isLoadedThread {
                        Color.secondary
                            .opacity(0.2)
                            .frame(width: 120, height: 16)
                    }
                    
                    // Not found text
                    if isLoadedThread && thread == nil {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text("thread_not_found")
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    // Thread title
                    if isLoadedThread && thread != nil {
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
            .listRowSeparator(.hidden, edges: .top)
            .listRowSeparator(.visible, edges: .bottom)
        }
        .listStyle(.plain)
        .onAppear(perform: load)
        
        .navigationTitle("comment")
        .navigationBarTitleDisplayMode(.inline)
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
        if thread == nil {
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
