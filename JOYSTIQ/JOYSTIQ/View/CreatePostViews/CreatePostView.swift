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
import UIKit

struct CreatePostView<APIServiceType: APIServiceProtocol>: View {
    // MARK: - Properties
    @EnvironmentObject var user: User
    var apiService: APIServiceType

    var s3Service: S3ServiceProtocol = S3Service()
    
    @Binding var isPresented: Bool //controls open state of entire view

    @State private var text = ""
    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    @State private var isMediaPickerShown = false
    @State private var uploadInProgress = false
    @State private var uploadCompleted = false
    @State private var isLoading: Bool = false
    //game dropdown vars
    @State private var game: String = ""
    @State private var isGamePickerShown: Bool = false
    //caption text limit
    @State private var characterLimit = 500

    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            headerView
            imageTitleView
            contentForm
            Spacer()
            
            if uploadInProgress {
                loadingOverlay
            }
        }
        .background(Color("GradientDark"))
        .preferredColorScheme(.dark) // Force dark mode
    }

    // MARK: - Subviews
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // To ensure it covers the entire screen
    }
    
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
            .frame(width: ScreenUtil.width * 0.55, height: 30)
            .padding(.top, 30)
    }

    private var contentForm: some View {
        VStack(alignment: .leading, spacing: 0) {
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
            
            GameDropdown(game: $game, isGamePickerShown: $isGamePickerShown)
            divider
            
            captionTextField

        }
        .frame(width: ScreenUtil.width * 0.9)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.top, 15)
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
    

    private var selectMediaButton: some View {
        Button("Select Media") {
            isMediaPickerShown = true
        }
        .sheet(isPresented: $isMediaPickerShown) {
            MediaPicker(selectedImage: $selectedImage, selectedVideoURL: $selectedVideoURL, isPickerShown: $isMediaPickerShown, sourceType: .photoLibrary)
                .presentationDetents([.fraction(0.8)])
        }
        .padding(.leading, 15)
        .padding(.vertical, 15)
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
        .padding(.vertical, 15)
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
        .padding(.vertical, 15)
    }

    private var captionTextField: some View {
        //custom text field for clear background, text wrapping, and scrollview
        //TD: Add Char limit?
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text("Enter Caption")
                    .foregroundColor(Color.gray)
                    .padding(.top, 15)
                    .padding(.leading, 15)
            }
            
            TextEditor(text: $text)
                .autocapitalization(.none)
                .padding(10)
                .scrollContentBackground(.hidden) //opaque background
                .background(Color.clear)
                .foregroundColor(Color.white)
                .frame(width: ScreenUtil.width * 0.9, height: 100, alignment: .leading)
                .onChange(of: text) { newText in
                                if newText.count > characterLimit {
                                    text = String(newText.prefix(characterLimit))
                                }
                            }
        }
    }
    
    private var divider: some View {
        Divider()
            .frame(height: 1)
            .background(Color.gray.opacity(0.2))
            .frame(width: ScreenUtil.width * 0.9)
    }

    // MARK: - Functions
    func uploadContent() {
        let uniqueKey: String

        if let image = selectedImage {
            uniqueKey = "\(UUID().uuidString).png"
            guard let imageData = image.pngData() else {
                print("Failed to convert UIImage to Data")
                return
            }
            uploadData(imageData, withKey: uniqueKey)
        } else if let videoURL = selectedVideoURL {
            uniqueKey = "\(UUID().uuidString).mov"
            do {
                let videoData = try Data(contentsOf: videoURL)
                uploadData(videoData, withKey: uniqueKey) { success in
                    if success {
                        // Once video is uploaded successfully, generate and upload the thumbnail
                        if let thumbnailImage = thumbnail(from: videoURL), let thumbnailData = thumbnailImage.pngData() {
                            let thumbnailKey = "\(UUID().uuidString).png"
                            uploadData(thumbnailData, withKey: thumbnailKey) { success in
                                if success {
                                    // Now both video and thumbnail are uploaded, create the post
                                    print("CALLING CREATE MEDIA POST WITH THUMBNAIL")
                                    createMediaPost(with: uniqueKey, thumbnailS3Key: thumbnailKey)
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Error reading video data: \(error)")
            }
        } else if !text.isEmpty {
            print("No media selected for upload. Proceeding with text.")
            createDiscussionPost()
        } else {
            print("Failed to create post: Both media and text body are empty.")
        }
    }
    
    func thumbnail(from url: URL, at time: TimeInterval = 1.0) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: time, preferredTimescale: 600)
        var actualTime = CMTimeMake(value: 0, timescale: 0)
        let cgImage: CGImage
        do {
            cgImage = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }

    // Modified the uploadData function to include a completion callback
    func uploadData(_ data: Data, withKey key: String, completion: @escaping (Bool) -> Void) {
        uploadInProgress = true
        Task {
            do {
                let s3Key = try await s3Service.uploadData(data, withKey: key)
                print("Uploaded successfully with key: \(s3Key)")
                completion(true)
            } catch {
                print("Error uploading: \(error)")
                uploadInProgress = false
                completion(false)
            }
        }
    }

    func uploadData(_ data: Data, withKey key: String) {
        uploadInProgress = true
        Task {
            do {
                let s3Key = try await s3Service.uploadData(data, withKey: key)
                print("Uploaded successfully with key: \(s3Key)")
                print("CALLING CREATE MEDIA POST WITH THUMBNAIL")
                createMediaPost(with: s3Key)
            } catch {
                print("Error uploading: \(error)")
                uploadInProgress = false
            }
        }
    }


    func createDiscussionPost() {
        let postData = PostData(media: "none", game: game, body: text, status: "live")
        
        Task {
            
            apiService.createPost(email: user.email, postData: postData) { result in
                    switch result {
                    case .success():
                        print("Post created successfully!")
                    case .failure(let error):
                        print("Error creating post: \(error.localizedDescription)")
                    }
                }


            uploadInProgress = false
            isPresented = false
        }
    }
    
    func createMediaPost(with s3Key: String, thumbnailS3Key: String? = nil) {
        let mediaType: String
        if selectedImage != nil {
            mediaType = "photo"
        } else if selectedVideoURL != nil {
            mediaType = "video"
        } else {
            mediaType = "none"
        }
        
        if mediaType == "none" {
            print("Error when setting media")
            uploadInProgress = false
            isPresented = false
            return
        }

        var postData = PostData(media: mediaType, game: game, body: text, status: "live")
        
        if mediaType == "video" {
            postData.s3_key = S3Key(String: s3Key, Valid: true)
            if let thumbnail = thumbnailS3Key {
                print("SETTING THUMBNAIL")
                postData.thumbnail_s3_key = S3Key(String: thumbnail, Valid: true)
            }
        } else { // photo
            postData.s3_key = S3Key(String: s3Key, Valid: true)
        }
        
        Task {
            apiService.createPost(email: user.email, postData: postData) { result in
                switch result {
                case .success():
                    print("Post created successfully!")
                case .failure(let error):
                    print("Error creating post: \(error.localizedDescription)")
                }
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
            .frame(width: ScreenUtil.width * 0.2, height: 35)
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
        let testUser = User(email: "testEmail@example.com", username: "testUsername")
        
        return CreatePostView<MockAPIService>(apiService: MockAPIService(), s3Service: MockS3Service(), isPresented: $isPresented)
            .environmentObject(testUser)
    }
}

