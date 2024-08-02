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
    var apiService: APIServiceType
    
    @State private var username: String = ""
    @State private var isAvailable: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            usernameRules
            usernameTextField
            if (username.count >= 3) {
                status
            }
            Spacer()
        }
        .background(Color("GradientDark3"))
    }
    
    // MARK: - Subviews
    private var usernameRules: some View {
        VStack {
            Text("Allowed characters: A-Z, a-z, 0-9, _, and -")
                .foregroundColor(.gray)
                .font(.system(size: ScreenUtil.width * 0.04))
            Text("Must start with a letter and be 3-15 characters long.")
                .font(.system(size: ScreenUtil.width * 0.04))
                .foregroundColor(.gray)
        }
    }
    
    private var usernameTextField: some View {
        HStack(spacing: ScreenUtil.width * 0.02) {
            
            TextField("", text: $username)
                .placeholder(when: username.isEmpty) {
                    Text("Enter Username").foregroundColor(Color.gray.opacity(0.6))
                }
                .autocapitalization(.none)
                .onChange(of: username) { _ in
                    checkUsernameAvailability()
                }
            
                .foregroundColor(Color.white)
                .padding()
                .background(Color.gray.opacity(0.15))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.6), lineWidth: 1))
            
            updateButton
        }
        .padding(.horizontal, ScreenUtil.width * 0.03)
        
    }
    
    private var updateButton: some View {
        Button(action: {
            if (isValidUsername(username) && isAvailable) {
                updateUsername()
            }

        }, label: {
            Text("Update")
                .padding()
                .background(LinearGradient(
                    gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                ))
                .opacity(isValidUsername(username) && isAvailable ? 1 : 0.4) //dim when username not valid / available
                .disabled(!isValidUsername(username) || !isAvailable)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .contentShape(Rectangle())
        })
    }
    
    private var status: some View {
        Group {
            if !isValidUsername(username) {
                Text("Invalid Username!")
                    .foregroundColor(.red)
            } else if isAvailable {
                Text("Username is available!")
                    .foregroundColor(.green)
            } else {
                Text("Username is taken!")
                    .foregroundColor(.red)
            }
        }
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
        
        apiService.checkUsernameAvailability(username: safeUsername) { result in
            isLoading = false
            switch result {
            case .success(let available):
                isAvailable = available
            case .failure(let error):
                print("Error checking username availability: \(error)")
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
        apiService.updateUsername(email: user.email, newUsername: username) { result in
            switch result {
            case .success:
                let userIdentifier: UserIdentifier = .email(user.email)
                apiService.getUsername(for: userIdentifier) { result in
                    switch result {
                    case .success(let username):
                        user.username = username
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

// MARK: - Preview
struct EditUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "test@test.com", username: "TestUser")
        EditUsernameView<MockAPIService>(apiService: MockAPIService())
            .environmentObject(testUser)
    }
}
