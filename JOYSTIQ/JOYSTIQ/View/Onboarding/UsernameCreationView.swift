//
//  UsernameCreateView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/6/23.
//

import Foundation
import SwiftUI

struct UsernameCreationView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @State private var username: String = ""
    @State private var isAvailable: Bool? = nil
    @State private var isLoading: Bool = false
    var APIService: APIServiceType
    
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
            if isAvailable! {
                Text("Username is available!")
                    .foregroundColor(.green)
            } else {
                Text("Username is taken!")
                    .foregroundColor(.red)
            }
        }
    }
    
    private var createUsernameButton: some View {
        Button("Create Username") {
            // Implement the logic for creating the username here
        }
        .padding()
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    
    // MARK: - Functions
    private func checkUsernameAvailability() {
        isLoading = true
        APIService.checkUsernameAvailability(username: username) { result in
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
}

// MARK: - Preview
struct UsernameCreationView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameCreationView<MockAPIService>(APIService: MockAPIService())
    }
}
