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


struct CreatePostView: View {
    @Binding var showing: Bool

    @State private var title = ""
    @State private var game = ""
    @State private var text = ""
    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    @State private var isMediaPickerShown = false
    @State private var uploadInProgress = false
    @State private var uploadCompleted = false
    
    @ObservedObject var s3Service = S3Service()

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Game", text: $game)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .frame(height: 100)
                        .border(Color.gray, width: 1)
                    if text.isEmpty {
                        Text("Questing, grinding, or chilling? Share your journey.")
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                            .padding(.top, 8)
                    }
                }
                
                if selectedImage != nil {
                    VStack {
                        Text("Image selected")
                        Button("Delete Image") {
                            selectedImage = nil
                        }
                        .foregroundColor(.red)
                    }
                }
                
                if selectedVideoURL != nil {
                    VStack {
                        Text("Video selected")
                        Button("Delete Video") {
                            selectedVideoURL = nil
                        }
                        .foregroundColor(.red)
                    }
                }

                Button("Select Media") {
                    isMediaPickerShown = true
                }
                .sheet(isPresented: $isMediaPickerShown) {
                    MediaPicker(selectedImage: $selectedImage, selectedVideoURL: $selectedVideoURL, isPickerShown: $isMediaPickerShown, sourceType: .photoLibrary)
                }

                Button("Submit") {
                    uploadContent()
                }
                .disabled(uploadInProgress)
            }
            .navigationTitle("New Post")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        // Dismiss the sheet:
                        showing = false
                    }
                }
            }
        }
    }
    
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
        } else {
            print("No media selected for upload.")
        }
    }

    func uploadData(_ data: Data) {
        uploadInProgress = true

        Task {
            do {
                let key = try await s3Service.uploadData(data)
                print("Uploaded successfully with key: \(key)")
            } catch {
                print("Error uploading: \(error)")
            }
            
            uploadInProgress = false
            showing = false  // Dismiss the sheet here
        }
    }

}




struct CreateView_Previews: PreviewProvider {
    @State static private var isPresented = true

    static var previews: some View {
        CreatePostView(showing: $isPresented)
    }
}

