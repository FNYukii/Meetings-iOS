//
//  ContentView.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("TabBarBackground"))
    }
    
    var body: some View {
        TabView {
            FirstView()
                .tabItem {
                    Image(systemName: "house")
                }
            
            SecondView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
        }
    }
}
