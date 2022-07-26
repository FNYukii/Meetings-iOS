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
    let iconImageFamily: IconImageFamily
    
    var body: some View {
        WebImage(url: URL(string: url ?? ""))
            .resizable()
            .placeholder {
                Color.secondary
                    .opacity(0.2)
            }
            .scaledToFill()
            .frame(width: iconImageFamily.rawValue, height: iconImageFamily.rawValue)
            .cornerRadius(.infinity)
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
    }
}

enum IconImageFamily: CGFloat {
    case small = 32
    case medium = 40
}
