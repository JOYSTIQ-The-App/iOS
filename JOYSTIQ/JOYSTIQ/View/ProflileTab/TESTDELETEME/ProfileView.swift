//
//  ProfileView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/14/23.
//

import SwiftUI

// ProfileView to display the original image
struct ProfileView: View {
    @ObservedObject var imageModel: ImageModel
    
    var body: some View {
        if let image = imageModel.originalImage {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
        } else {
            Text("No image available")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
