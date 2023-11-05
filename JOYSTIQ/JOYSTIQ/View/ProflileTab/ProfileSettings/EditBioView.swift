//
//  EditResumeView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/2/23.
//

import Foundation
import SwiftUI

struct EditBioView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var apiService: APIServiceType

    @State private var bioText: String = ""
    @State private var isSaving: Bool = false
    @State private var hasEditedBio: Bool = false

    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Text("Tell us a little about yourself!")
                .font(.headline)
            
            bioTextField
            
            if hasEditedBio {
                saveButton
            }
        }
        .padding()
        .onAppear(perform: fetchUserBio)
        .preferredColorScheme(.dark)
    }

    // MARK: - Subviews
    private var bioTextField: some View {
        TextField("Enter your bio...", text: $bioText, onEditingChanged: { _ in
            hasEditedBio = true
        })
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
    }

    private var saveButton: some View {
        Button(action: saveBio) {
            if isSaving {
                ProgressView()
            } else {
                Text("Save")
            }
        }
        .disabled(isSaving)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }

    // MARK: - Functions
    func fetchUserBio() {
        apiService.getUserBio(for: user.username) { result in
            switch result {
            case .success(let bio):
                self.bioText = bio.bio
            case .failure(let error):
                print("Error fetching user bio: \(error.localizedDescription)")
            }
        }
    }

    func saveBio() {
        isSaving = true
        apiService.updateUserProfile(username: user.username, bio: bioText, resume: nil) { result in
            switch result {
            case .success:
                print("Bio updated successfully!")
                presentationMode.wrappedValue.dismiss() // <-- Dismiss the view here
            case .failure(let error):
                print("Error updating bio: \(error.localizedDescription)")
            }
            isSaving = false
        }
    }
}

// MARK: - Preview
struct EditBioView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "test@test.com", username: "TestUser")
        
        return EditBioView(apiService: MockAPIService())
            .environmentObject(testUser)
    }
}
