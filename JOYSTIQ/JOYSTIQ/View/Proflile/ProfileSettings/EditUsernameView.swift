//
//  UsernameCreateView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/6/23.
//

import Foundation
import SwiftUI

struct EditUsernameView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    var APIService: APIServiceType
    
    @State private var username: String = ""
    @State private var isAvailable: Bool? = nil
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            usernameTextField
            checkAvailabilityButton
            
            if let isAvailable = isAvailable {
                availabilityText
                if isAvailable {
                    createUsernameButton
                }
            }
        }
        .padding()
    }
    
    // MARK: - Subviews
    private var usernameTextField: some View {
        TextField("Enter Username", text: $username)
            .onChange(of: username) { _ in
                isAvailable = nil
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
    }
    
    private var checkAvailabilityButton: some View {
        Button(action: checkUsernameAvailability) {
            if isLoading {
                ProgressView()
            } else {
                Text("Check Availability")
            }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .disabled(isLoading || username.isEmpty)
    }
    
    private var availabilityText: some View {
        Group {
            if !isValidUsername(username) {
                VStack {
                    Text("Invalid Username!")
                        .foregroundColor(.red)
                    Text("Allowed: A-Z, a-z, 0-9, _, and -.")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Must start with a letter and be 3-15 characters long.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } else if isAvailable! {
                Text("Username is available!")
                    .foregroundColor(.green)
            } else {
                Text("Username is taken!")
                    .foregroundColor(.red)
            }
        }
    }
    
    private var createUsernameButton: some View {
        Button("Update Username") {
            updateUsername()
        }
        .padding()
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    
    // MARK: - Functions
    private func checkUsernameAvailability() {
        // First validate the username locally.
        if !isValidUsername(username) {
            isAvailable = false
            return
        }
        
        isLoading = true
        let safeUsername = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        APIService.checkUsernameAvailability(username: safeUsername) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let available):
                    isAvailable = available
                case .failure(let error):
                    print("Error checking username availability: \(error)")
                }
            }
        }
    }
    
    private func isValidUsername(_ username: String) -> Bool {
        let usernameRegex = "^[a-zA-Z][a-zA-Z0-9_-]{2,14}$"
        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegex)
        return usernameTest.evaluate(with: username)
    }
    
    private func updateUsername() {
        isLoading = true
        APIService.updateUsername(email: user.email, newUsername: username) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let userIdentifier: UserIdentifier = .email(user.email)
                    APIService.getUsername(for: userIdentifier) { result in
                        switch result {
                        case .success(let username):
                            DispatchQueue.main.async {
                                user.username = username
                            }
                        case .failure(let error):
                            print("Error getting username: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Error updating username: \(error)")
                    errorMessage = "Failed to update username. Please try again."
                }
                isLoading = false
            }
        }
    }

}

// MARK: - Preview
struct EditUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "test@test.com", username: "TestUser")
        EditUsernameView<MockAPIService>(APIService: MockAPIService())
            .environmentObject(testUser)
    }
}
