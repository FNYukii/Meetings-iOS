//
//  CommentImagesRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI

struct CommentImagesRow: View {
    
    let comment: Comment
    
    var body: some View {
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
    }
}
