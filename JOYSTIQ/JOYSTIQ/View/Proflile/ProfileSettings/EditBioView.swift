//
//  EditResumeView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 10/2/23.
//

import Foundation
import SwiftUI

struct EditBioView<APIServiceType: APIServiceProtocol>: View {
    @EnvironmentObject var user: User
    var apiService: APIServiceType

    @State private var bioText: String = ""
    @State private var isSaving: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter your bio...", text: $bioText)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

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
        .padding()
    }

    func saveBio() {
        isSaving = true
        apiService.updateUserProfile(username: user.username, bio: bioText, resume: nil) { result in
            switch result {
            case .success:
                // Handle success, perhaps show a confirmation message or navigate back
                print("Bio updated successfully!")
            case .failure(let error):
                // Handle the error, perhaps show an error message to the user
                print("Error updating bio: \(error.localizedDescription)")
            }
            isSaving = false
        }
    }
}


struct EditBioView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = User(email: "test@test.com", username: "TestUser")
        
        return EditBioView(apiService: MockAPIService())
            .environmentObject(testUser)
    }
}
