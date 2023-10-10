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

struct FollowersResponse: Decodable {
    let followers: [String]
}

struct FollowingResponse: Decodable {
    let following: [String]
}
