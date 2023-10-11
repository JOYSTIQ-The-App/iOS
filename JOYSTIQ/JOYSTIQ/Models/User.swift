//
//  User.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/21/23.
//

import Foundation

class User: ObservableObject {
    @Published var email: String
    @Published var username: String
    
    init(email: String, username: String) {
        self.email = email
        self.username = username
    }
}

struct UserData: Codable {
    var email: String
    var username: String
}

// Struct for decoding the JSON response from the server
struct UsernameAvailabilityResponse: Decodable {
    let availability: Bool
}

struct EmailRegisteredResponse: Decodable {
    let isRegistered: Bool
}

struct CreateUserPayload: Encodable {
    let email: String
    let username: String
    let role: String
    let account: String
}
