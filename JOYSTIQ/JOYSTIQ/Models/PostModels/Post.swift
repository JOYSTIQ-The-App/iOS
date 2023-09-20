//
//  Post.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/19/23.
//

import Foundation

struct Post: Codable, Identifiable {
    var id: Int
    var user_id: Int
    var s3_key: String?
    var media: String
    var title: String
    var game: String
    var body: String
    var status: String
    var likes: Int
    var created_at: String
    var updated_at: String?
    var likes_count: Int?
}
