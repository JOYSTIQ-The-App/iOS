//
//  EditResumeView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/2/23.
//

import Foundation
import SwiftUI

struct EditSocialsView<APIServiceType: APIServiceProtocol>: View {
    @EnvironmentObject var user: User
    var apiService: APIServiceType
    
    let allSocials = ["discord", "kick", "twitch", "youtube", "xbox", "playstation"]

    @State private var selectedSocial: String = "discord"
    @State private var username: String = ""
    @State private var currentSocials: [String: String] = [:]
    @State private var isSaving: Bool = false
    @State private var showingDeleteConfirmation = false
    @State private var socialToDelete: String?

    private var isUsernameValid: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 20) {
            ForEach(currentSocials.sorted(by: <), id: \.key) { key, value in
                HStack {
                    Text(key.capitalized).bold() + Text(": \(value)")
                    Spacer()
                    Button(action: {
                        self.socialToDelete = key
                        self.showingDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .actionSheet(isPresented: $showingDeleteConfirmation) {
                ActionSheet(
                    title: Text("Delete Social"),
                    message: Text("Are you sure you want to delete \(socialToDelete?.capitalized ?? "")?"),
                    buttons: [
                        .destructive(Text("Delete")) {
                            if let type = socialToDelete {
                                deleteUserSocial(socialType: type)
                            }
                        },
                        .cancel()
                    ]
                )
            }
            
            Divider().padding(.vertical, 10)

            Picker("Select a Social", selection: $selectedSocial) {
                ForEach(allSocials, id: \.self) {
                    Text($0.capitalized)
                }
            }
            .pickerStyle(MenuPickerStyle())

            TextField("Enter username for \(selectedSocial)", text: $username)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            
            Button(action: saveSocial) {
                if isSaving {
                    ProgressView()
                } else {
                    Text("Save")
                }
            }
            .disabled(!isUsernameValid || isSaving)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .onAppear {
            fetchUserSocials()
        }
    }

    func fetchUserSocials() {
        apiService.getUserSocials(for: user.username) { result in
            switch result {
            case .success(let socials):
                self.currentSocials = socials ?? [:]
            case .failure(let error):
                print("Error fetching user's socials: \(error.localizedDescription)")
            }
        }
    }
    
    func saveSocial() {
        isSaving = true
        
        apiService.updateUserSocials(username: user.username, socialType: selectedSocial, socialUsername: username) { result in
            DispatchQueue.main.async {
                isSaving = false
                switch result {
                case .success():
                    currentSocials[selectedSocial] = username
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func deleteUserSocial(socialType: String) {
        isSaving = true
        
        apiService.deleteUserSocial(username: user.username, socialType: socialType) { result in
            DispatchQueue.main.async {
                isSaving = false
                switch result {
                case .success():
                    currentSocials[socialType] = nil
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct EditSocialsView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "test@test.com", username: "TestUser")
        return EditSocialsView(apiService: MockAPIService())
            .environmentObject(testUser)
    }
}
