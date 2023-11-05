//
//  ImageModel.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/14/23.
//

import Foundation
import SwiftUI

// Model or ViewModel to store and manage image data
class ImageModel: ObservableObject {
    @Published var originalImage: UIImage?
    @Published var modifiedImage: UIImage?
    
    // You might add more properties or methods to manage the images
}

