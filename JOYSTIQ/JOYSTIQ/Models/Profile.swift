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

struct Bio: Codable {
    var bio: String
}
