//
//  FollowersListView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/2/23.
//

import SwiftUI

struct FollowersListView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    var APIService: APIServiceType
    @EnvironmentObject var user: User
    
    @State private var followers: [String] = []
    
    // MARK: - Body
    var body: some View {
        List(followers, id: \.self) { follower in
            Text(follower)
        }
        .navigationBarTitle("Followers", displayMode: .inline)
        .onAppear(perform: fetchFollowers)
    }
    
    // MARK: - Functions
    func fetchFollowers() {
        APIService.getFollowersList(for: user.username) { result in
            switch result {
            case .success(let followersList):
                self.followers = followersList
            case .failure(let error):
                // Handle error, maybe with an alert or something similar
                print("Error fetching followers: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Preview
struct FollowersListView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "TestUser")
        
        return FollowersListView<MockAPIService>(APIService: MockAPIService())
            .environmentObject(testUser)
    }
}

