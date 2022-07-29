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
    
    // States
    @State var scaleValue: CGFloat = 1.0
    
    var body: some View {
        
        NavigationView {
            WebImage(url: URL(string: url ?? ""))
                .resizable()
                .placeholder {
                    Color.secondary
                        .opacity(0.2)
                }
                .scaledToFit()
                .scaleEffect(scaleValue)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            self.scaleValue = value
                        }
                )
                
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
