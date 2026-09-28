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
    @State private var showingActionSheet = false
    
    private var isUsernameValid: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
            VStack(spacing: 20) {
                Spacer()
                
                SocialsList
                
                Divider().padding(.vertical, 10)

                AddSocials
                
                Spacer()
            }
            .background(Color("GradientDark3"))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                fetchUserSocials()
            }
            .alert(isPresented: $showingDeleteConfirmation) {
                Alert(
                    title: Text("Delete Social"),
                    message: Text("Are you sure you want to delete \(socialToDelete?.capitalized ?? "") username?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let type = socialToDelete {
                            deleteUserSocial(socialType: type)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Select a Social"), buttons: actionSheetButtons())
            }
        }
    
    //MARK: - Subviews
    private var SocialsList: some View {
        ForEach(currentSocials.sorted(by: <), id: \.key) { key, value in
            HStack {
                Image(key + "Logo")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(4)
                
                Text("\(value)")
                    .foregroundColor(Color("LightGray"))
                    .font(.system(size: 20))
                Spacer()
                Button(action: {
                    self.socialToDelete = key
                    self.showingDeleteConfirmation = true
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal, 20)
            
        }
    }
    
    private var AddSocials: some View {
        
        HStack(spacing: ScreenUtil.width * 0.02) {
            
            VStack {
                Button(action: {
                    showingActionSheet = true
                }) {
                    HStack {
                        Image(selectedSocial + "Logo")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(4)
                        Image(systemName: "chevron.up")
                            .foregroundColor(.white)
                    }
                    .padding(13)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                
            }
            
            TextField("", text: $username)
                .placeholder(when: username.isEmpty) {
                    Text("Enter username").foregroundColor(Color.gray.opacity(0.6))
                }
                .padding()
                .background(Color.gray.opacity(0.15))
                .foregroundColor(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.6), lineWidth: 1))
            
            Button(action: saveSocial) {
                if isSaving {
                    ProgressView()
                } else {
                    Text("Save")
                }
            }
            .disabled(!isUsernameValid || isSaving)
            .padding()
            .background(LinearGradient(
                gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            ))
            .opacity((!isUsernameValid || isSaving) ? 0.4 : 1)
            .foregroundColor(Color.white)
            .cornerRadius(8)
            .contentShape(Rectangle())
        }
        .padding(.horizontal, ScreenUtil.width * 0.02)
    }

    //MARK: - Functions
    private func actionSheetButtons() -> [ActionSheet.Button] {
            var buttons = allSocials.map { social in
                ActionSheet.Button.default(Text(social.capitalized)) {
                    selectedSocial = social
                }
            }
            buttons.append(.cancel())
            return buttons
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
            isSaving = false
            switch result {
            case .success():
                currentSocials[selectedSocial] = username
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func deleteUserSocial(socialType: String) {
        isSaving = true
        
        apiService.deleteUserSocial(username: user.username, socialType: socialType) { result in
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

struct EditSocialsView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "test@test.com", username: "TestUser")
        return EditSocialsView(apiService: MockAPIService())
            .environmentObject(testUser)
    }
}
