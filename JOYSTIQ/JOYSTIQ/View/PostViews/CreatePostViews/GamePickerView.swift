//
//  GamePicker.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/30/23.
//

import SwiftUI

struct GamePickerView: View {
    @Binding var selectedGame: String
    var dismissAction: () -> Void
    
    @State private var searchText = ""
    @State private var customGameName = ""
    @State private var matchingGames: [String] = Array(GameData.gamesDictionary.keys)

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                TextField("Type your own game", text: $customGameName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .disableAutocorrection(true)
                
                Button("Set") {
                    if !customGameName.isEmpty {
                        self.selectedGame = customGameName
                        self.dismissAction()
                    }
                }
                .padding(.horizontal)
            }

            TextField("Search for a game", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .onChange(of: searchText) { newValue in
                    updateMatchingGames(with: newValue)
                }
                .disableAutocorrection(true)

            List(matchingGames, id: \.self) { gameName in
                Button(action: {
                    self.selectedGame = gameName
                    self.dismissAction()
                }) {
                    Text(gameName)
                }
            }
        }
        .padding(.top)
    }
    
    func updateMatchingGames(with query: String) {
        if query.isEmpty {
            matchingGames = Array(GameData.gamesDictionary.keys)
        } else {
            matchingGames = GameData.gamesDictionary.keys.filter { $0.lowercased().contains(query.lowercased()) }
        }
    }
}


// Preview provider
struct GamePickerView_Previews: PreviewProvider {
    static var previews: some View {
        GamePickerView(selectedGame: .constant(""), dismissAction: {})
    }
}
