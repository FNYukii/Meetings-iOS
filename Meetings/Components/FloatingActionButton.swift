//
//  FloatingActionButton.swift
//  Meetings
//
//  Created by Yu on 2022/09/22.
//

import SwiftUI

struct FloatingActionButton: View {
    
    // Environments
    @Environment(\.colorScheme) var colorScheme
    
    // Values
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
                            Color.accentColor.opacity(0.9)
                        }
                        .cornerRadius(.infinity)
                }
                .background(colorScheme == .light ? .white : .black)
                .cornerRadius(.infinity)
                .padding(.trailing)
                .padding(.bottom)
            }
        }
    }
}
