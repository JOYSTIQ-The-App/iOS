//
//  ProfileTabView.swift
//  JOYSTIQ
//
//  Created by cs dev on 4/10/23.
//

import SwiftUI
import SceneKit

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct ProfileTabView: View {
    
    //handles logged state
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        
        ScrollView (.vertical, showsIndicators: true) {
            
            VStack { //Main VStack
                
                
                VStack(spacing: 0) { //VStack for avatar / bio / username overlay
                    
                    VStack {
                        
                        SceneKitView(named: "skintone6")
                            .frame(height: 350)
                            //.offset(y: 20)
                            .edgesIgnoringSafeArea(.top)
                            
                        //Rectangle()
                            //.frame(width: UIScreen.main.bounds.width, height: 310)
                            //.foregroundColor(.clear)
                        
                        
                    }
                    .background(
                        Image("default3")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
                    
                    
                    
                        
                    VStack { //VStack for Bio and Social/resume buttons
                           
                        HStack(spacing: 20) { //Socials hstack
                            
                            Button( action: {
                                    //button action here
        
                                
                                }, label: {
                                    //PAGE CONTENT
                                    
                                    Image(systemName: "network")
                                        .font(.system(size: 33))
                                        .foregroundColor(.green)
                                    
                                })
                            
                            
                            //Username banner
                            Text("User12345")
                                .frame(width: 200, height: 40)
                                .font(.system(size: 22))
                                .foregroundColor(.black)
                                .background(Color("ColorGreen"))
                                .cornerRadius(20)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                            
                            
                            
                            Button( action: {
                                    //button action here
                                }, label: {
                                    
                                    Image(systemName: "list.bullet.clipboard.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.green)
                                    
                                })
                            
                            
                        } //END Socials HStack
                        
                        
                        Text("I am the cod goat \nFollow me on twitch.tv/codGoat \n100T content creator")
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 30, height: 90, alignment: .topLeading)
                            .font(.system(size: 16))
                            .foregroundColor(Color("LightGray"))
                            .background(Color("Black0"))
                            .cornerRadius(15)
                            
               
                        
                    } //END bio vstack
                        
       
                    
                    
                }
                
                
                //Accolade banner
                AccoladeBanner()
                
                //Content filter
                GameDropDownMenu()
                    .padding(15)
                    .frame(width: UIScreen.main.bounds.width)
                    .offset(x: -120)
                
                Spacer()
              
           
                
                Text("<< CONTENT GOES HERE >>")
                    .foregroundColor(.gray)
                    .frame(height: 300)
                    .font(.system(size: 25))
                    .padding(.bottom, 50)
                    .offset(y: -50)
                
                Button("Logout") {
                    Task {
                        await authService.signOutLocally()
                        await authService.fetchCurrentAuthSession()
                    }
                }
                .foregroundColor(.black)
                .frame(width: 120.0, height: 50.0)
                .background(Color("AccentColor"))
                .cornerRadius(10)
                
                Spacer()
                    .frame(height: 100.0)
                
            }//End Main VStack
            .background(Color("Black1"))
            
            
        } //End Scroll View
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        
    } //END BODY
}


//For rounding specific corners
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct GameDropDownMenu: View {
    let options = ["VALORANT", "Call of Duty", "Halo", "Apex"]
    @State private var selectedOption = "VALORANT"
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    self.selectedOption = option
                }) {
                    Text(option)
                }
            }
        } label: {
            
            HStack() {
                
                Image(systemName: "gamecontroller.fill")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(width: 20, height: 20)
                
                Text(selectedOption)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        }
        .frame(width: UIScreen.main.bounds.width / 3, height: 40)
        .padding(.leading, 10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.leading, 20)
        
    }
}

struct SceneKitView: UIViewRepresentable {
    
    let scene: SCNScene

    init(named name: String) {
        
        
         
        guard let loadedScene = Self.loadScene(named: name) else {
            fatalError("Failed to load the scene: \(name)")
        }
        self.scene = loadedScene
        
        //configureCamera()
      
        //-----------------------START COSMETIC ADD ONS--------------------------

        // Load the Hair model
        let shortsURL = Bundle.main.url(forResource: "elenahair", withExtension: "usdc")!
        let shortsScene = try! SCNScene(url: shortsURL, options: nil)
        let shortsNode = shortsScene.rootNode
        
        var currentPosition = shortsNode.position
        
        // Update the y-component of the position to move it up
        currentPosition.z += 0.27

        // Assign the updated position back to the node
        shortsNode.position = currentPosition
        
        //add shorts as scene node
        scene.rootNode.addChildNode(shortsNode)
        
        // Load the flip flops model
        let flopsURL = Bundle.main.url(forResource: "flops", withExtension: "usdc")!
        let flopsScene = try! SCNScene(url: flopsURL, options: nil)
        let flopsNode = flopsScene.rootNode
        
        var currPosition = flopsNode.position
        
        // Update the y-component of the position to move it up
        currPosition.z += 0.27

        // Assign the updated position back to the node
        flopsNode.position = currPosition
        
        //add shorts as scene node
        scene.rootNode.addChildNode(flopsNode)

        
        // Load the sword model
        let backURL = Bundle.main.url(forResource: "sword", withExtension: "usdc")!
        let backScene = try! SCNScene(url: backURL, options: nil)
        let backNode = backScene.rootNode
        
        var curPosition = backNode.position
        
        // Update the y-component of the position to move it up
        curPosition.z += 0.48
        curPosition.y += 0.04
        

        // Assign the updated position back to the node
        backNode.position = curPosition
        
        //add shorts as scene node
        scene.rootNode.addChildNode(backNode)
        
   
         
        // Load the glasses model
        let glassesURL = Bundle.main.url(forResource: "glasses", withExtension: "usdc")!
        let glassesScene = try! SCNScene(url: glassesURL, options: nil)
        let glassesNode = glassesScene.rootNode
        
        //rotation
        // Rotate the glasses by 45 degrees around the y-axis
        let rotationAngle = Float(-90.0 * Double.pi / 180.0)
        let rotation = SCNVector4(x: 0, y: 0, z: 1, w: rotationAngle)
        glassesNode.rotation = rotation
        
        //positioning
        var curPos = glassesNode.position
        curPos.z += 0.42
        curPos.x -= 0.04
        curPos.y += 0.02
        glassesNode.position = curPos
        
        // Scale the node down to about 70 percent of its current size
        let scalePercentage: Float = 0.8
        glassesNode.scale = SCNVector3(x: scalePercentage, y: scalePercentage, z: scalePercentage)

        
        //add shorts as scene node
        scene.rootNode.addChildNode(glassesNode)
        
        //-----------------------END COSMETIC ADD ONS--------------------------
        

        
        createDirectionalLight(color: UIColor.white, intensity: 500.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(-Float.pi / 2, 0, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 500.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(Float.pi / 2, 0, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 200.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(0, 0, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 500.0, position: SCNVector3(x: 0, y: -Float.pi / 2, z: 0), direction: SCNVector3(0, -Float.pi / 2, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 500.0, position: SCNVector3(x: 0, y: Float.pi / 2, z: 0), direction: SCNVector3(0, Float.pi / 2, 0))
        
    

         
     
    }

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
    
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.clear
        
        
        return scnView
    }
    
 

    func updateUIView(_ scnView: SCNView, context: Context) {
        // Update the SCNView if needed
    }


    private static func loadScene(named name: String) -> SCNScene? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "usdc") else {
            print("Failed to find the .dae file: \(name).usdc")
            return nil
        }
        
        guard let sceneSource = SCNSceneSource(url: url, options: nil),
              let scene = sceneSource.scene(options: nil) else {
            print("Failed to load the scene: \(name).usdc")
            return nil
        }
        
        

        return scene
    }
    
    
    private func createSpotlight(color: UIColor, intensity: CGFloat, position: SCNVector3, direction: SCNVector3) -> SCNNode {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .spot
        lightNode.light?.color = color
        lightNode.light?.intensity = intensity
        lightNode.position = position
        lightNode.eulerAngles = direction
        
        scene.rootNode.addChildNode(lightNode)
        return lightNode
    }

    private func createDirectionalLight(color: UIColor, intensity: CGFloat, position: SCNVector3, direction: SCNVector3) -> SCNNode {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional
        lightNode.light?.color = color
        lightNode.light?.intensity = intensity
        lightNode.position = position
        lightNode.eulerAngles = direction
        
        scene.rootNode.addChildNode(lightNode)
        return lightNode
    }
   


    /* WORKING CAMERA FUNC - FACES TOP PERSPECTIVE
    private func configureCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 13 // Adjust this value to change the zoom level (lower value means more zoomed in)
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 8)
        let target = SCNVector3(x: 0, y: 0, z: 0)
        let cameraDirection = SCNVector3(x: 0, y: 0, z: -1)
        cameraNode.look(at: target, up: SCNVector3(0, 1, 0), localFront: cameraDirection)

        
        scene.rootNode.addChildNode(cameraNode)
    }
     */
    


}






struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView()
    }
}
