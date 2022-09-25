//
//  Comment.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase
import Foundation

struct Comment: Identifiable {
    let id: String
    let createdAt: Date
    let userId: String
    
    let threadId: String
    let text: String
    let imageUrls: [String]
}
