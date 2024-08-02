//
//  FollowersListView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/2/23.
//

import SwiftUI

struct FollowersListView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    var apiService: APIServiceType
    var username: String
    
    @State private var followers: [String] = []
    
    // MARK: - Body
    var body: some View {
        List(followers, id: \.self) { user in
            NavigationLink(destination: OtherProfileView(apiService: apiService, profileUsername: user)) {
                Text(user)
                    .font(.system(size: 15))
            }
        }
        .navigationBarTitle("Followers", displayMode: .inline)
        .onAppear(perform: fetchFollowers)
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Functions
    func fetchFollowers() {
        apiService.getFollowersList(for: username) { result in
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
        return FollowersListView<MockAPIService>(apiService: MockAPIService(), username: "Apical")
    }
}

