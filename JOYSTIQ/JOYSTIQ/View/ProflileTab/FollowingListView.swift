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
    var username: String
    
    @State private var following: [String] = []
    
    // MARK: - Body
    var body: some View {
        List(following, id: \.self) { user in
            NavigationLink(destination: OtherProfileView(apiService: apiService, profileUsername: user)) {
                Text(user)
                    .font(.system(size: 15))
            }
        }
        .navigationBarTitle("Following", displayMode: .inline)
        .onAppear(perform: fetchFollowing)
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Functions
    func fetchFollowing() {
        apiService.getFollowingList(for: username) { result in
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
        return FollowingListView<MockAPIService>(apiService: MockAPIService(), username: "Apical")
    }
}

