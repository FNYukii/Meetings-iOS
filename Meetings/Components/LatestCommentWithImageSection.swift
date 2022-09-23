//
//  RecentlyPostedImageSection.swift
//  Meetings
//
//  Created by Yu on 2022/09/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct LatestCommentWithImageSection: View {
    
    // States
    @State private var comment: Comment? = nil
    @State private var isLoaded = false
    
    // Navigations
    @State private var isShowCommentView = false
    
    var body: some View {
        
        Button(action: {
            isShowCommentView.toggle()
        }) {
            // Progress
            if !isLoaded {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }
            
            // Failed
            if isLoaded && comment == nil {
                Text("reading_failed")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }
            
            // Done
            if isLoaded && comment != nil {
                ZStack(alignment: .bottomLeading) {
                    // Image Layer
                    WebImage(url: URL(string: comment?.imageUrls.first ?? ""))
                        .resizable()
                        .placeholder {
                            Color.secondary
                                .opacity(0.2)
                        }
                        .frame(height: 250)
                        .scaledToFit()
                    
                    // Text Layer
                    Text(comment!.text)
                        .padding()
                }
                .background {
                    NavigationLink(destination: CommentView(comment: comment!), isActive: $isShowCommentView) {
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
        if comment == nil {
            FireComment.readCommentWithImage() { comment in
                self.comment = comment
                self.isLoaded = true
            }
        }
    }
}
