//
//  User.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/21/23.
//

import Foundation

class User: ObservableObject {
    @Published var email: String?
    @Published var username: String?
    
    init(email: String? = nil, username: String? = nil) {
        self.email = email
        self.username = username
    }
}
