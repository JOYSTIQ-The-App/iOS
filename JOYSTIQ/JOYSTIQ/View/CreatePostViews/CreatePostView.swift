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


struct CreatePostView<APIServiceType: APIServiceProtocol, S3ServiceType: S3ServiceProtocol, AuthServiceType: AuthServiceProtocol & ObservableObject>: View {
    var APIService: APIServiceType
    var s3Service: S3ServiceType
    @EnvironmentObject var authService: AuthServiceType
    
    @Binding var isPresented: Bool

    @State private var game = ""
    @State private var text = ""
    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    @State private var isMediaPickerShown = false
    @State private var uploadInProgress = false
    @State private var uploadCompleted = false

    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack { //HStack for close button and title
                
                // cancel button
                Button( action: {
                    //button action here
                    isPresented = false
                    
                }, label: {
                    
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.gray)
                    
                })
                .offset(x: 10)

                Spacer()
                
                Image("createapost")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.55, height: 30)
                    .background(.clear)
                
            } //end HStack for close button and title
            .frame(width: UIScreen.main.bounds.width * 0.77)
            
    
            Form {
                
                TextField("Game", text: $game)
                
                Button("Select Media") {
                    isMediaPickerShown = true
                }
                .sheet(isPresented: $isMediaPickerShown) {
                    MediaPicker(selectedImage: $selectedImage, selectedVideoURL: $selectedVideoURL, isPickerShown: $isMediaPickerShown, sourceType: .photoLibrary)
                        .presentationDetents([.fraction(0.8)])
                }
                
                if selectedImage != nil {
                    HStack {
                        Text("Image selected")
                        Spacer()
                        Button("Remove Image") {
                            selectedImage = nil
                        }
                        .foregroundColor(.red)
                    }
                }
                
                if selectedVideoURL != nil {
                    HStack {
                        Text("Video selected")
                        Spacer()
                        Button("Remove Video") {
                            selectedVideoURL = nil
                        }
                        .foregroundColor(.red)
                    }
                }
                
    
                ZStack(alignment: .topLeading) {
                    
                    TextEditor(text: $text)
                        .frame(minHeight: 60)
                        .zIndex(1)
                    
                    if text.isEmpty {
                        
                        Text("Questing, grinding, or chilling? Share your journey.")
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                            .padding(.top, 8)
                            .zIndex(0)
                    }
                    
                }
                
                
            } //end form
            .frame(width: UIScreen.main.bounds.width)

            
            
            VStack(alignment: .center) {
                
                //Post button
                Button(action: {
                    uploadContent()
                    
                }, label: {
                    Text("Post")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: 45)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("GradientLight2"), Color("GradientDark2")]),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                        .cornerRadius(30)
                })
                .contentShape(Rectangle())
                .disabled(uploadInProgress)
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.bottom, 30)
            
            Spacer()
            
        } //end VStack
        .background(.black)
            
        
    } //end body
    
/*
    func getSize(of image: UIImage) -> String {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return "Unknown size"
        }
        let size = Double(data.count) / (1024 * 1024) // MB
        return String(format: "%.2f MB", size)
    }
    
    func getSize(of url: URL) -> String {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSizeNumber = fileAttributes[.size] as? NSNumber {
                let fileSize = fileSizeNumber.doubleValue
                let sizeInMB = fileSize / (1024 * 1024)
                return String(format: "%.2f MB", sizeInMB)
            }
        } catch {
            print("Error accessing file size: \(error)")
        }
        return "Unknown size"
    }
*/
    
    func uploadContent() {
        // If an image is selected, convert to Data and upload
        if let image = selectedImage {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("Failed to convert UIImage to Data")
                return
            }
            uploadData(imageData)

        // If a video is selected, read its data and upload
        } else if let videoURL = selectedVideoURL {
            do {
                let videoData = try Data(contentsOf: videoURL)
                uploadData(videoData)
            } catch {
                print("Error reading video data: \(error)")
            }
            
        // If no media is selected, just proceed to post creation
        } else {
            print("No media selected for upload.")
            createPost(with: nil)  // Passing nil for the s3_key
        }
    }
    
    func uploadData(_ data: Data) {
        uploadInProgress = true

        Task {
            do {
                let s3Key = try await s3Service.uploadData(data)
                print("Uploaded successfully with key: \(s3Key)")
                createPost(with: s3Key) // Call createPost with the uploaded s3Key
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

        // Fetch the user's email and create the post
        Task {
            if let email = try? await authService.fetchUserEmail() {
                APIService.createPost(email: email, postData: postData) { result in
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
            isPresented = false  // Dismiss the sheet here
        }
    }
}




struct CreateView_Previews: PreviewProvider {
    @State static private var isPresented = true

    static var previews: some View {
        CreatePostView<MockAPIService, MockS3Service, MockAuthService>(APIService: MockAPIService(), s3Service: MockS3Service(), isPresented: $isPresented)
            .environmentObject(MockAuthService())
    }
}
