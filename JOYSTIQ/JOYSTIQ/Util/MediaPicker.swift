//
//  ImagePicker.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/13/23.
//

import SwiftUI
import UIKit

struct MediaPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var selectedVideoURL: URL?
    @Binding var isPickerShown: Bool
    var sourceType: UIImagePickerController.SourceType
    
    typealias UIViewControllerType = UIImagePickerController

    func makeUIViewController(context: UIViewControllerRepresentableContext<MediaPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.mediaTypes = ["public.image", "public.movie"]
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<MediaPicker>) {
        // This method is left intentionally blank
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: MediaPicker

        init(_ parent: MediaPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = uiImage
                parent.selectedVideoURL = nil
            } else if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                parent.selectedVideoURL = videoURL
                parent.selectedImage = nil
            }
            parent.isPickerShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPickerShown = false
        }
    }
}
