//
//  PostData.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/19/23.
//

import Foundation

struct PostData: Codable {
    var s3_key: String?
    var media: String
    var game: String
    var body: String
    var status: String
}
