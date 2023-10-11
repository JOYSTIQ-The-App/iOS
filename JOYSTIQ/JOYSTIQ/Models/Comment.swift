//
//  Comment.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/25/23.
//

import Foundation

struct Comment: Codable, Identifiable {
    var id: Int
    var post_id: Int
    var user_id: Int
    var text: String
    var created_at: String
    var username: String
}

struct CommentData: Codable {
    let post_id: Int
    let username: String
    let text: String
}

