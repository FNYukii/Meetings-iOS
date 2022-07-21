//
//  ThreadRow.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import SwiftUI

struct ThreadRow: View {
    
    let thread: Thread
    
    var body: some View {
        
        NavigationLink(destination: ThreadView()) {
            
            VStack(alignment: .leading) {
                Text(thread.title)
                    .fontWeight(.bold)
                
                Text("hello")
                    .foregroundColor(.secondary)
                Text("1 Comments")
                    .foregroundColor(.secondary)
            }
            
        }
    }
}
