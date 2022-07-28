//
//  CommentImage.swift
//  Meetings
//
//  Created by Yu on 2022/07/28.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentImage: View {
    
    let url: String?
    
    var body: some View {
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
}
