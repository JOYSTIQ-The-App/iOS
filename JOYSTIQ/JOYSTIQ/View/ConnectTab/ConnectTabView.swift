//
//  ConnectTabView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI

struct ConnectTabView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    var apiService: APIServiceType
    @EnvironmentObject var user: User
    
    @State private var searchText: String = "search"
    @State private var foundUsernames: [String] = []
    @State private var isLoading: Bool = false
    @State private var searched: Bool = false
    @FocusState private var isEditing

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                clearSearch
                
                //result viewer
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                }
                else if searched {
                    ResultViewer(apiService: apiService, usernames: foundUsernames)
                }
                
                Spacer()
                
            } // END MAIN VSTACK
            .frame(width: UIScreen.main.bounds.width)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("GradientDark"), Color("GradientDark3")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .preferredColorScheme(.dark)
            
        } //end Nav View
        .edgesIgnoringSafeArea(.all)
        
    } //end body
    
    private var clearSearch: some View { //search bar with clear button
        
        ZStack(alignment: .trailing) {
            
            searchbar
            
            if searchText != "search" && searchText != "" {
                
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("LightGray"))
                }
                .offset(x: -30)
                
            }
            
            
            
            
        }
        .frame(width: UIScreen.main.bounds.width)
    }
    
    
    private var searchbar: some View {
        
        ZStack(alignment: .leading) { //Search bar ZStack
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("ColorGreen"))
                .padding(.leading, 15)
                .scaledToFit()
                .scaleEffect(1.5)

            TextField("search for a username", text: $searchText, onCommit: {
                searchForUsernames()
            })
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(.vertical, 8)
            .padding(.leading, 50)
            .background(Color.gray.opacity(0.2))
            .accentColor(.green)
            .foregroundColor(Color("LightGray"))
            .font(.system(size: UIScreen.main.bounds.height * 0.022))
            .onTapGesture {
                isEditing = true
                if searchText == "search" {
                    searchText = ""
                }
            }
            .onSubmit {
                isEditing = false
                searched = true
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
        .padding(.vertical, 20)
        
    }

    func searchForUsernames() {
        isLoading = true
        let lowercaseSearchText = searchText.lowercased()  // Convert to lowercase
        apiService.searchUsernames(for: lowercaseSearchText) { result in
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
}//end struct

struct ConnectTabView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "testEmail@example.com", username: "Apical")
        
        return ConnectTabView<MockAPIService>(apiService: MockAPIService())
            .environmentObject(testUser)
    }
}
