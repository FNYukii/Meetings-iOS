//
//  CommentImagesRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI

struct CommentImagesRow: View {
    
    // Comment to show
    let comment: Comment
    
    // Navigation
    let isAbleShowingImageView: Bool
    
    var body: some View {
        Group {
            if comment.imageUrls.count == 1 {
                CommentImage(url: comment.imageUrls.first, isAbleShowingImageView: isAbleShowingImageView)
            }
            
            if comment.imageUrls.count == 2 {
                HStack {
                    CommentImage(url: comment.imageUrls.first, isAbleShowingImageView: isAbleShowingImageView)
                    CommentImage(url: comment.imageUrls[1], isAbleShowingImageView: isAbleShowingImageView)
                }
            }
            
            if comment.imageUrls.count == 3 {
                HStack {
                    CommentImage(url: comment.imageUrls.first, isAbleShowingImageView: isAbleShowingImageView)
                    CommentImage(url: comment.imageUrls[1], isAbleShowingImageView: isAbleShowingImageView)
                }
                
                CommentImage(url: comment.imageUrls[2], isAbleShowingImageView: isAbleShowingImageView)
            }
            
            if comment.imageUrls.count == 4 {
                HStack {
                    CommentImage(url: comment.imageUrls.first, isAbleShowingImageView: isAbleShowingImageView)
                    CommentImage(url: comment.imageUrls[1], isAbleShowingImageView: isAbleShowingImageView)
                }
                
                HStack {
                    CommentImage(url: comment.imageUrls[2], isAbleShowingImageView: isAbleShowingImageView)
                    CommentImage(url: comment.imageUrls[3], isAbleShowingImageView: isAbleShowingImageView)
                }
            }
        }
    }
}
