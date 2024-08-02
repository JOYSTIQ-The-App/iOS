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
    @State private var characterLimit = 500

    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Tell us a little about yourself!")
                .font(.headline)
                .foregroundColor(Color("LightGray"))
            bioTextField
            saveButton
            Spacer()
        }
        .frame(width: ScreenUtil.width)
        .onAppear(perform: fetchUserBio)
        .background(Color("GradientDark3"))
        
    }

    // MARK: - Subviews
    private var bioTextField: some View {
        //custom text field for clear background, text wrapping, and scrollview
        ZStack(alignment: .topLeading) {
            if bioText.isEmpty {
                Text("Enter your bio...")
                    .foregroundColor(Color.gray)
                    .padding(.top, 15)
                    .padding(.leading, 15)
            }
            
            TextEditor(text: $bioText)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(10)
                .scrollContentBackground(.hidden) //opaque background
                .foregroundColor(Color.white)
                .frame(width: ScreenUtil.width * 0.9, height: 200, alignment: .leading)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
                .onChange(of: bioText) { newText in
                    if newText.count > characterLimit {
                        bioText = String(newText.prefix(characterLimit))
                    }
                }
        }
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.6), lineWidth: 1))
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
        .padding(.vertical, 15)
        .padding(.horizontal, 50)
        .background(LinearGradient(
            gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        ))
        .foregroundColor(Color.white)
        .opacity(1)
        .cornerRadius(10)
        .contentShape(Rectangle())
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
