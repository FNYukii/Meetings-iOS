//
//  RecentlyPostedImageSection.swift
//  Meetings
//
//  Created by Yu on 2022/09/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct LatestThreadWithImageSection: View {
    
    // States
    @State private var comment: Comment? = nil
    @State private var isLoadedComment = false
    
    @State private var thread: Thread? = nil
    @State private var isLoadedThread = false
    
    // Navigations
    @State private var isShowCommentView = false
    
    var body: some View {
        
        Button(action: {
            isShowCommentView.toggle()
        }) {
            // Progress
            if !isLoadedComment || !isLoadedThread {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }
            
            // Failed
            if isLoadedComment && comment == nil || isLoadedThread && thread == nil {
                Text("reading_failed")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // Done
            if isLoadedComment && comment != nil && isLoadedThread && thread != nil {
                ZStack(alignment: .bottom) {
                    // Image Layer
                    WebImage(url: URL(string: comment?.imageUrls.first ?? ""))
                        .resizable()
                        .placeholder {
                            Color.secondary
                                .opacity(0.2)
                        }
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                    
                    // Thread Title Layer
                    ZStack(alignment: .bottomLeading) {
                        // Shadow Layer
                        LinearGradient(gradient: Gradient(colors: [.black.opacity(0.6), .clear]), startPoint: .bottom, endPoint: .top)
                        
                        // Foreground Layer
                        Text(thread!.title)
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                .background {
                    NavigationLink(destination: ThreadView(threadId: thread!.id, threadTitle: thread!.title), isActive: $isShowCommentView) {
                        EmptyView()
                    }
                    .hidden()
                }
            }
        }
        .buttonStyle(.plain)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .onAppear(perform: load)
    }
    
    private func load() {
        if comment == nil || thread == nil {
            FireComment.readCommentWithImage() { comment in
                self.comment = comment
                self.isLoadedComment = true
                
                FireThread.readThread(threadId: comment?.threadId ?? "") { thread in
                    self.thread = thread
                    self.isLoadedThread = true
                }
            }
        }
    }
}
