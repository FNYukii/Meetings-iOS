//
//  ImageView.swift
//  Meetings
//
//  Created by Yu on 2022/07/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageView: View {
    
    // Environments
    @Environment(\.dismiss) private var dismiss
    
    // Image to show
    let url: String?
    
    var body: some View {
        
        NavigationView {
            WebImage(url: URL(string: url ?? ""))
                .resizable()
                .placeholder {
                    Color.secondary
                        .opacity(0.2)
                }
                .scaledToFit()
                
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("done")
                                .fontWeight(.bold)
                        }
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}
