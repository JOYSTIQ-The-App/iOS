//
//  FollowingListView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/2/23.
//

import Foundation
import SwiftUI

struct FollowingListView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    var apiService: APIServiceType
    @EnvironmentObject var user: User
    
    @State private var following: [String] = []
    
    // MARK: - Body
    var body: some View {
        List(following, id: \.self) { user in
            Text(user)
        }
        .navigationBarTitle("Following", displayMode: .inline)
        .onAppear(perform: fetchFollowing)
    }
    
    // MARK: - Functions
    func fetchFollowing() {
        apiService.getFollowingList(for: user.username) { result in
            switch result {
            case .success(let followingList):
                self.following = followingList
            case .failure(let error):
                // Handle error, maybe with an alert or something similar
                print("Error fetching following users: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Preview
struct FollowingListView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "TestUser")
        
        return FollowingListView<MockAPIService>(apiService: MockAPIService())
            .environmentObject(testUser)
    }
}

