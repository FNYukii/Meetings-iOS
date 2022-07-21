//
//  FirstView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct FirstView: View {
    
    @State private var isShowProfileView = false
    
    var body: some View {
        NavigationView {
            
            List {
                Text("HELLO")
            }
            
            .sheet(isPresented: $isShowProfileView) {
                ProfileView()
            }
            
            .navigationTitle("threads")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShowProfileView.toggle()
                    }) {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
