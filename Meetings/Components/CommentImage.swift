//
//  CommentImage.swift
//  Meetings
//
//  Created by Yu on 2022/07/28.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentImage: View {
    
    // Image to show
    let url: String?
    
    // Navigation
    @State private var isShowImageView = false
    
    var body: some View {
        Button(action: {
            isShowImageView.toggle()
        }) {
            WebImage(url: URL(string: url ?? ""))
                .resizable()
                .placeholder {
                    Color.secondary
                        .opacity(0.2)
                }
                .scaledToFill()
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
        }
        .buttonStyle(.borderless)
        
        .sheet(isPresented: $isShowImageView) {
            ImageView(url: url)
        }
    }
}
