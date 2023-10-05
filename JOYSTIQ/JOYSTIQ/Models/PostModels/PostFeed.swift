//
//  PostFeed.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/4/23.
//

import Foundation

import Foundation

struct FeedPost: Codable, Identifiable {
    var id: Int
    var user_id: Int
    var s3_key: S3Key?
    var media: String
    var game: String
    var body: String?
    var status: String
    var likes: Int
    var comments: Int
    var created_at: String
    var user_liked: Bool
}
