//
//  ImageView.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    
    // Image to show
    let url: String?
    
    var body: some View {
        
        WebImage(url: URL(string: url ?? ""))
            .resizable()
            .placeholder {
                Color.secondary
                    .opacity(0.2)
            }
        
    }
}
