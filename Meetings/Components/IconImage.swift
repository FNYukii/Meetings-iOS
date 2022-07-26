//
//  IconImage.swift
//  Meetings
//
//  Created by Yu on 2022/07/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct IconImage: View {
    
    let url: String?
    
    var body: some View {
        WebImage(url: URL(string: url ?? ""))
            .resizable()
            .placeholder {
                Color.secondary
                    .opacity(0.2)
            }
            .frame(width: 40, height: 40)
            .cornerRadius(.infinity)
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
    }
}
