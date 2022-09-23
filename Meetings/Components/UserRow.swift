//
//  UserRow.swift
//  Meetings
//
//  Created by Yu on 2022/09/21.
//

import SwiftUI

struct UserRow: View {
    
    let user: User
    
    var body: some View {
        HStack(alignment: .top) {
            // Icon Column
            UserIconImage(userId: user.id, iconImageFamily: .medium)
            
            // Detail Column
            VStack(alignment: .leading) {
                // Display Name Row
                UserDisplayNameText(userId: user.id)
                
                // User Tag Row
                UserUserTagText(userId: user.id)
                
                // Introduction Row
                Text(user.introduction)
            }
        }
        .background(NavigationLink("", destination: UserView(userId: user.id)).opacity(0))
    }
}
