//
//  CommentData.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/26/23.
//

import Foundation

struct CommentData: Codable {
    let post_id: Int
    let username: String
    let text: String
}
