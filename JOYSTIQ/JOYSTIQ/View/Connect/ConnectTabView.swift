//
//  ConnectTabView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI

struct ConnectTabView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    var APIService: APIServiceType
    
    @State private var searchText: String = "search"
    @State private var foundUsernames: [String] = []
    @State private var isLoading: Bool = false
    @FocusState private var isEditing

    var body: some View {
        VStack {
            ZStack(alignment: .leading) { //Search bar ZStack
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("ColorGreen"))
                    .padding(.leading, 15)
                    .scaledToFit()
                    .scaleEffect(1.5)

                TextField("Search for a username", text: $searchText, onCommit: {
                    searchForUsernames()
                })
                .padding(.vertical, 8)
                .padding(.leading, 50)
                .background(Color.gray.opacity(0.2))
                .accentColor(.green)
                .foregroundColor(Color("LightGray"))
                .font(.system(size: 20))
                .onTapGesture {
                    isEditing = true
                    if searchText == "search" {
                        searchText = ""
                    }
                }
                .onSubmit {
                    isEditing = false
                }
                .focused($isEditing)

                if searchText.isEmpty {
                    Text(searchText)
                        .foregroundColor(Color("LightGray"))
                        .padding(.leading, 55)
                        .font(.system(size: 25))
                }
            } //END Search bar ZStack
            .cornerRadius(360)
            .padding(.horizontal, 20)
            .onTapGesture {
                isEditing = false
            }
            .padding(.vertical, 30)

            if isLoading {
                ProgressView()
            } else {
                List(foundUsernames, id: \.self) { username in
                    Text(username)
                }
            }
        } // END MAIN VSTACK
        .background(Color("Black0"))
    }

    func searchForUsernames() {
        isLoading = true
        let lowercaseSearchText = searchText.lowercased()  // Convert to lowercase
        APIService.searchUsernames(for: lowercaseSearchText) { result in
            isLoading = false
            switch result {
            case .success(let usernames):
                foundUsernames = usernames
            case .failure(let error):
                print("Error searching for usernames: \(error.localizedDescription)")
                // Handle the error appropriately, e.g., show an alert to the user
            }
        }
    }
}

struct ConnectTabView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectTabView<MockAPIService>(APIService: MockAPIService())
    }
}
