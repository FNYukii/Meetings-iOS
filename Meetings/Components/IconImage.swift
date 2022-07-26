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
    let iconSize: IconSize
    
    var body: some View {
        WebImage(url: URL(string: url ?? ""))
            .resizable()
            .placeholder {
                Color.secondary
                    .opacity(0.2)
            }
            .frame(width: iconSize.rawValue, height: iconSize.rawValue)
            .cornerRadius(.infinity)
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
    }
}

enum IconSize: CGFloat {
    case small = 32
    case large = 40
}
