//
//  FloatingActionButton.swift
//  Meetings
//
//  Created by Yu on 2022/09/22.
//

import SwiftUI

struct FloatingActionButton: View {
    
    let systemImage: String
    let action: (() -> Void)
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    action()
                }) {
                    Image(systemName: systemImage)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background {
                            Color.white
                            Color.accentColor.opacity(0.8)
                        }
                        .cornerRadius(.infinity)
                }
                .padding(.trailing)
                .padding(.bottom)
            }
        }
    }
}
