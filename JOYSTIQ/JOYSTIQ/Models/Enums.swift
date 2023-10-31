//
//  Enums.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/19/23.
//

import Foundation

enum UserIdentifier {
    case email(String)
    case userId(Int)
}

enum MediaType {
    case photo, video, none
    
    init(from string: String?) {
        switch string {
        case "photo":
            self = .photo
        case "video":
            self = .video
        default:
            self = .none
        }
    }
}

enum FeedType: String, CaseIterable {
    case following, global
}
