//
//  GameDropdown.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 7/23/24.
//

import SwiftUI

struct GameDropdown: View {
    @Binding var game: String
    @Binding var isGamePickerShown: Bool
    @State private var games: [String] = Array(GameData.gamesDictionary.keys.sorted())
    @State private var filteredGames: [String] = []
    
    var body: some View {
        VStack {
            HStack {
                TextField(text: $game)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 15)
                    .background(Color.clear)
                    .foregroundColor(.white)
                    .onChange(of: game) { newValue in
                        filterGames(query: newValue)
                        isGamePickerShown = !newValue.isEmpty && !filteredGames.isEmpty
                    }
                    .placeholder(when: game.isEmpty) {
                        Text("Select Game")
                            .foregroundColor(Color.gray)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 15)
                    }
                
                Spacer()
                
                if !game.isEmpty {
                    Button(action: {
                        game = ""
                        isGamePickerShown = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if isGamePickerShown {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(filteredGames, id: \.self) { game in
                            Text(game)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.clear)
                                .cornerRadius(5)
                                .contentShape(Rectangle()) //Ensures entire frame is clickable
                                .onTapGesture {
                                    self.game = game
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                        withAnimation {
                                            self.isGamePickerShown = false
                                        }
                                    }
                                }
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color.gray.opacity(0.2)),
                                    alignment: .bottom
                                )
                        }
                    }
                }
                .frame(maxHeight: 200) // Adjust the height as needed
                .background(Color.black.opacity(0.2))
            }
        }
    }
    
    private func filterGames(query: String) {
            if query.isEmpty {
                filteredGames = []
            } else {
                filteredGames = games.filter { $0.localizedCaseInsensitiveContains(query) }
            }
            // Hide the picker if there are no filtered results
            if filteredGames.isEmpty {
                isGamePickerShown = false
            }
        }
}

struct GameDropdown_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper()
    }
}

struct StatefulPreviewWrapper: View {
    @State private var game: String = ""
    @State private var isGamePickerShown: Bool = true

    var body: some View {
        GameDropdown(game: $game, isGamePickerShown: $isGamePickerShown)
            .background(Color("GradientDark"))
    }
}
