//
//  S3Service.swift
//  JOYSTIQ
//
//  Created by Stephen Sottosanti on 9/12/23.
//

import SwiftUI
import Amplify
import AWSS3StoragePlugin

class S3Service: ObservableObject {
    
    // Uploads the provided data to S3 and returns the key
    func uploadData(_ data: Data) async throws -> String {
        let key = UUID().uuidString // Generate a unique key for each upload
        
        let uploadTask = Amplify.Storage.uploadData(key: key, data: data)
        
        Task {
            for await progress in await uploadTask.progress {
                print("Progress: \(progress.fractionCompleted)")
            }
        }
        
        let _ = try await uploadTask.value
        print("Upload completed for key: \(key)")
        
        return key
    }
}
