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
    @State private var matchingGames: [String] = Array(GameData.gamesDictionary.keys.sorted())

    var body: some View {
        VStack {
            TextField("Search for a game", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.2))
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
        .preferredColorScheme(.dark)
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
