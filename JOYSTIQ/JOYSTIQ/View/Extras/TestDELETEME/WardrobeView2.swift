//
//  WardrobeView2.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/14/23.
//

import SwiftUI


import SwiftUI

struct WardrobeView2: View {

    
    //@Binding var sceneView: SceneKitView
    @State private var sceneKitView = SceneKitView(named: "skintone6")
    
    //vars for avatar image modifications
    @Binding var profileImage: UIImage?

 
    var body: some View {
        
        VStack (spacing: 0) { //Main VStack for sceneKitView and wardrobe controls
            
            
            Divider()
                .frame(height: 5)
                .background(Color.gray)
                   
            sceneKitView
                .frame(height: UIScreen.main.bounds.height * 0.5)
            
            
            Divider()
                .frame(height: 5)
                .background(Color.gray)
            
            //avatar image
            if let image = profileImage {
                
                Image(uiImage: image)
                    .resizable()
                    .background(.red)
                    .foregroundColor(.red)
                    .accentColor(.red)
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.5)
                
                
            }
            else {
                Text("No image selected")
                    .frame(width: 100, height: 50)
            }
            
            
            //Confirm code button
            Button(action: {
                
                self.profileImage = sceneKitView.takeSnapshot()
   
                
            }, label: {
                
                Text("Save")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width * 0.35, height: 45)
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
   
            
            
            
            
            
        
            
        } //end Main VStack for scenekitview and wardrobe controls
        .edgesIgnoringSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.gray)

        
    }
    
}

/*
struct WardrobeView2: View {
    @Binding var profileImage: UIImage?
    @State private var modifiedImage: UIImage?

    var body: some View {
        
        VStack {
            
            // Display the modified image if available
            if let image = modifiedImage ?? profileImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } else {
                Text("No image selected")
            }

            
            
            Button(action: {
                // Simulate modifying the image
                self.modifiedImage = UIImage(systemName: "star.fill")
            }) {
                Text("Modify Image")
            }

            
            
            Button(action: {
                // Save the modified image back to the profile view
                self.profileImage = self.modifiedImage
            }) {
                Text("Save Changes")
            }
        }
        .navigationBarTitle("Wardrobe")
    }
}
*/



/*
struct WardrobeView2_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView2()
    }
}
*/

struct WardrobeView2_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView2(profileImage: .constant(UIImage(systemName: "person.circle")!))
        //profileImage: .constant(UIImage(systemName: "person.circle")!)
    }
}
