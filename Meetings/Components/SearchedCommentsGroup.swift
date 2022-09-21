//
//  SearchedCommentsGroup.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct SearchedCommentsGroup: View {
    
    let keyword: String
    
    @State private var comments: [Comment]? = nil
    @State private var isLoaded = false
    
    var body: some View {
        Group {
            // Progress
            if !isLoadedComments {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }

            // Failed
            if isLoaded && comments == nil {
                Text("reading_failed")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }

            // No Results
            if isLoaded && comments != nil && comments!.count == 0 {
                Text("no_results")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
                    .listRowSeparator(.hidden)
            }

            // Done
            if isLoaded && comments != nil {
                ForEach(comments!) { comment in
                    CommentRow(comment: comment, isAbleShowingProfileView: true, isShowThread: true)
                        .listRowSeparator(.hidden, edges: .top)
                        .listRowSeparator(.visible, edges: .bottom)
                }
            }
        }
        .onAppear(perform: load)
    }
    
    private func load() {
        if comments == nil {
            FireComment.readComments(keyword: keyword) { comments in
                self.comments = comments
                self.isLoaded = true
            }
        }
    }
}
