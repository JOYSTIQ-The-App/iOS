//
//  NewPostView.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/13/23.
//

import Foundation
import SwiftUI
import AVKit
import AVFoundation

struct CreatePostView<APIServiceType: APIServiceProtocol, AuthServiceType: AuthServiceProtocol & ObservableObject>: View {
    // MARK: - Properties
    var apiService: APIServiceType
    @EnvironmentObject var authService: AuthServiceType

    var s3Service: S3ServiceProtocol = S3Service()
    
    @Binding var isPresented: Bool

    @State private var game = ""
    @State private var text = ""
    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    @State private var isMediaPickerShown = false
    @State private var uploadInProgress = false
    @State private var uploadCompleted = false

    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            headerView
            imageTitleView
            contentForm
            Spacer()
        }
        .background(Color("GradientDark"))
        .preferredColorScheme(.dark) // Force dark mode
    }

    // MARK: - Subviews
    private var headerView: some View {
        HStack { // HStack for close button and title
            cancelButton
            Spacer()
            postButton
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width)
    }

    private var imageTitleView: some View {
        Image("createapost")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: UIScreen.main.bounds.width * 0.55, height: 30)
            .padding(.top, 30)
    }

    private var contentForm: some View {
        VStack(alignment: .leading, spacing: 10) {
            selectMediaButton
            divider
            if selectedImage != nil {
                imageSelectedInfo
                divider
            }
            if selectedVideoURL != nil {
                videoSelectedInfo
                divider
            }
            
            gameTextField
            divider
            
            captionTextField
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.25)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.top, 10)
    }

    private var cancelButton: some View {
        Button("Cancel") {
            // Dismiss the sheet:
            isPresented = false
        }
        .foregroundColor(.gray)
    }

    private var postButton: some View {
        Button(action: {
            uploadContent()
        }, label: {
            Text("Post")
                .foregroundColor(.white)
                .postButtonStyle()
        })
        .contentShape(Rectangle())
        .disabled(uploadInProgress)
    }

    private var gameTextField: some View {
        TextField("Game", text: $game)
            .padding(.top, 15)
            .padding(.leading, 15)
            .disableAutocorrection(true)
    }

    private var selectMediaButton: some View {
        Button("Select Media") {
            isMediaPickerShown = true
        }
        .sheet(isPresented: $isMediaPickerShown) {
            MediaPicker(selectedImage: $selectedImage, selectedVideoURL: $selectedVideoURL, isPickerShown: $isMediaPickerShown, sourceType: .photoLibrary)
                .presentationDetents([.fraction(0.8)])
        }
        .padding(.leading, 15)
        .padding(.vertical, 5)
    }

    private var imageSelectedInfo: some View {
        HStack {
            Text("Image selected")
            Spacer()
            Button("Remove Image") {
                selectedImage = nil
            }
            .foregroundColor(.red)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }

    private var videoSelectedInfo: some View {
        HStack {
            Text("Video selected")
            Spacer()
            Button("Remove Video") {
                selectedVideoURL = nil
            }
            .foregroundColor(.red)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }

    private var captionTextField: some View {
        TextField("Enter caption", text: $text)
            .padding(.leading, 10.0)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
            .foregroundColor(.white)
            .cornerRadius(10)
            .autocapitalization(.none)
    }

    private var divider: some View {
        Divider()
            .frame(height: 1)
            .background(Color.gray.opacity(0.2))
            .frame(width: UIScreen.main.bounds.width * 0.9)
    }

    // MARK: - Functions
    func uploadContent() {
        if let image = selectedImage {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("Failed to convert UIImage to Data")
                return
            }
            uploadData(imageData)
        } else if let videoURL = selectedVideoURL {
            do {
                let videoData = try Data(contentsOf: videoURL)
                uploadData(videoData)
            } catch {
                print("Error reading video data: \(error)")
            }
        } else if !text.isEmpty {
            print("No media selected for upload. Proceeding with text.")
            createPost(with: nil)
        } else {
            print("Failed to create post: Both media and text body are empty.")
        }
    }

    func uploadData(_ data: Data) {
        uploadInProgress = true
        Task {
            do {
                let s3Key = try await s3Service.uploadData(data)
                print("Uploaded successfully with key: \(s3Key)")
                createPost(with: s3Key)
            } catch {
                print("Error uploading: \(error)")
                uploadInProgress = false
            }
        }
    }

    func createPost(with s3Key: String?) {
        let mediaType: String
        if selectedImage != nil {
            mediaType = "photo"
        } else if selectedVideoURL != nil {
            mediaType = "video"
        } else {
            mediaType = "none"
        }

        let postData = PostData(s3_key: s3Key, media: mediaType, game: game, body: text, status: "live")

        if s3Key == nil && text.isEmpty {
            print("Failed to create post: Both media and text body are empty.")
            return
        }
        
        Task {
            if let email = try? await authService.fetchUserEmail() {
                apiService.createPost(email: email, postData: postData) { result in
                    switch result {
                    case .success():
                        print("Post created successfully!")
                    case .failure(let error):
                        print("Error creating post: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Error retrieving user email.")
            }

            uploadInProgress = false
            isPresented = false
        }
    }
}

// MARK: - Extensions
private extension Text {
    func postButtonStyle() -> some View {
        self
            .frame(width: UIScreen.main.bounds.width * 0.2, height: 35)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
            )
            .cornerRadius(10)
    }
}

// MARK: - Preview
struct CreateView_Previews: PreviewProvider {
    @State static private var isPresented = true

    static var previews: some View {
        CreatePostView<MockAPIService, MockAuthService>(apiService: MockAPIService(), s3Service: MockS3Service(), isPresented: $isPresented)
            .environmentObject(MockAuthService())
    }
}

