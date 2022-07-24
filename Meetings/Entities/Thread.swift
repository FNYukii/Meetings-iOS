//
//  Thread.swift
//  Meetings
//
//  Created by Yu on 2022/07/21.
//

import Firebase

struct Thread: Identifiable {
    let id: String
    let createdAt: Date
    let userId: String
    let title: String
}
