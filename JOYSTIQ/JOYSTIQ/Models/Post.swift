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
    var s3_key: S3Key?
    var media: String
    var game: String
    var body: String?
    var status: String
    var likes: Int
    var comments: Int
    var created_at: String
    var updated_at: String?
    var likes_count: Int?
    var user_liked: Bool?
}

struct PostData: Codable {
    var s3_key: String?
    var media: String
    var game: String
    var body: String
    var status: String
}

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

struct S3Key: Codable {
    let String: String
    let Valid: Bool
}
