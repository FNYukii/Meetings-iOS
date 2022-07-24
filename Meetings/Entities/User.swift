//
//  User.swift
//  Meetings
//
//  Created by Yu on 2022/07/23.
//

import Firebase

struct User: Identifiable {
    let id: String
    let displayName: String
    let userTag: String
    let introduction: String
    let iconUrl: String?
    let likes: [String]
}
