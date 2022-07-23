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
        
        VStack(alignment: .leading) {
            
            HStack {
                Text(thread.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Menu {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                        .padding(.vertical, 6)
                }
            }
            
            Text("0 Comments")
                .foregroundColor(.secondary)
        }
        .background( NavigationLink("", destination: ThreadView()).opacity(0))
        
    }
}
