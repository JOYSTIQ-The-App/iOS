//
//  ProfileView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/14/23.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var profileImage: UIImage? // State to hold the profile image
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 150, height: 150)
                    
                } else {
                    Text("No image selected")
                        .padding(.bottom, 50)
                }
                
                //NavigationLink(destination: WardrobeView2(profileImage: $profileImage)) {
                  //  Text("Edit Wardrobe")
                //}
                
            }
            .navigationBarTitle("Profile")
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(.gray)
        }
        
        
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
