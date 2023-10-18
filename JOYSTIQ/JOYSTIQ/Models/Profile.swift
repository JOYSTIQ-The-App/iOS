//
//  Profile.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/27/23.
//

import Foundation

struct Profile: Codable {
    var bio: String
    var resume: String
    var followers: Int
    var following: Int
}

struct UserProfile: Codable {
    var avatar_s3_key: S3Key
    var bio: String
    var environment: String
    var followers: Int
    var following: Int
    var posts: [Post]
    var resume: String
    var socials: [String: String]
}


struct Bio: Codable {
    var bio: String
}
