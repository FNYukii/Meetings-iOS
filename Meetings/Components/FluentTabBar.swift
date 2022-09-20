//
//  MyTabBar.swift
//  Meetings
//
//  Created by Yu on 2022/07/25.
//

import SwiftUI

struct FluentTabBar: View {
    
    // TabBar items
    let tabBarItems: [Text]
    
    // States
    @Binding var selection: Int
    @Environment(\.colorScheme) var colorScheme
    
    // Namespace
    @Namespace private var namespace
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // Button Row
            HStack(spacing: 0) {
                ForEach(0 ..< tabBarItems.count, id: \.self) { index in
                    Button(action: {
                        self.selection = index
                    }) {
                        VStack {
                            
                            // Label
                            tabBarItems[index]
                                .foregroundColor(self.selection == index ? .accentColor : .primary)
                            
                            // Color underline
                            if self.selection == index {
                                Color.accentColor
                                    .frame(height: 2)
                                    .padding(.horizontal)
                                    .matchedGeometryEffect(id: "underline", in: namespace)
                            }
                            
                            // Clear underline
                            if self.selection != index {
                                Color.clear
                                    .frame(height: 2)
                                    .padding(.horizontal)
                            }
                        }
                        .background(colorScheme == .dark ? Color.black : Color.white)
                        .animation(.spring(), value: selection)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top)
            
            // Underline Row
            Divider()
        }
    }
}
