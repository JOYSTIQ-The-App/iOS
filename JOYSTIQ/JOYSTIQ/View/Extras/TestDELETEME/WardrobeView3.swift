//
//  WardrobeView3.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/14/23.
//


import SwiftUI

struct WardrobeView3: View {
    
    @Binding var hideNavBar: Bool
    
    //@Binding var sceneView: SceneKitView
    @State private var sceneKitView = SceneKitView(named: "skintone6")
    
    //vars for avatar image modifications
    @State private var profileImage: UIImage?
    //@Binding var profileImage: UIImage?
    @State private var modifiedImage: UIImage?
 
    var body: some View {
        
        VStack (spacing: 0) { //Main VStack for sceneKitView and wardrobe controls
            
            
            
            Divider()
                .frame(height: 5)
                .background(Color.gray)
                   
            sceneKitView
                .frame(height: UIScreen.main.bounds.height * 0.2)
            
            
            Divider()
                .frame(height: 5)
                .background(Color.gray)
            
            if let image = profileImage {
                
                Image(uiImage: image)
                    //.resizable()
                    //.frame(width: 200, height: 350)
                
            } else {
                Text("No image selected")
            }

            
            
            
            //Confirm code button
            Button(action: {
                
                //self.image = sceneKitView.takeSnapshot()
                //self.modifiedImage = UIImage(systemName: "star")
                //self.modifiedImage = sceneKitView.takeSnapshot()
                //self.modifiedImage = sceneKitView.takeSnapshot()
                self.profileImage = self.modifiedImage
                
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
        .background(Color.clear)
        .onAppear {
            hideNavBar = true
        }
        
    }
    
}



struct WardrobeView3_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView3(hideNavBar: .constant(true))
        //profileImage: .constant(UIImage(systemName: "person.circle")!)
    }
}

