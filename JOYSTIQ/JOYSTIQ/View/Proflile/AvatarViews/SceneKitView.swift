//
//  SceneKitView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/10/23.
//

import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    
    @State private var nodeToRemoveName: String? = nil
    @State private var nodeToAddName: String? = nil
    
    let scene: SCNScene
    let skinColor: String

    init(named name: String, skinColor: String) {
        
        self.skinColor = skinColor
        
        guard let loadedScene = Self.loadScene(named: name) else {
            fatalError("Failed to load the scene: \(name)")
        }
        
        self.scene = loadedScene

        //initialize scene with selections
        //changeSkinTone(named: skinColor)
        
        //create light nodes
        createDirectionalLight(color: UIColor.white, intensity: 400.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(-Float.pi / 2, 0, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 400.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(Float.pi / 2, 0, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 200.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(0, 0, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 200.0, position: SCNVector3(x: 0, y: -Float.pi / 2, z: 0), direction: SCNVector3(0, -Float.pi / 2, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 200.0, position: SCNVector3(x: 0, y: Float.pi / 2, z: 0), direction: SCNVector3(0, Float.pi / 2, 0))
        
  
     
    }
    
    
    
    private static func loadScene(named name: String) -> SCNScene? {
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "usdc") else {
            print("Failed to find the .usdc file: \(name).usdc")
            return nil
        }
        
        guard let sceneSource = SCNSceneSource(url: url, options: nil),
              let scene = sceneSource.scene(options: nil) else {
            print("Failed to load the scene: \(name).usdc")
            return nil
        }
        
        return scene
    }

    func makeUIView(context: Context) -> SCNView {
        
        let scnView = SCNView()
    
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.clear
        scnView.showsStatistics = true
        
        return scnView
        
    }

    
    //function for removing nodes
    func removeNode(named name: String) {
        
        nodeToRemoveName = name
        
        if let nodeToRemove = scene.rootNode.childNode(withName: name, recursively: true) {
            nodeToRemove.removeFromParentNode()
        }
        
    }
    
    //function for adding nodes
    func addNode(named name: String) {
        
        // Load the Hair model
        let nodeURL = Bundle.main.url(forResource: name, withExtension: "usdc")!
        let nodeScene = try! SCNScene(url: nodeURL, options: nil)
        let newNode = nodeScene.rootNode

        
        //add shorts as scene node
        scene.rootNode.addChildNode(newNode)
        
    }
    
    //function for removing one node and adding another
    func replaceNode(named name: String, named name2: String) {
        
        if let nodeToRemove = scene.rootNode.childNode(withName: name, recursively: true) {
            nodeToRemove.removeFromParentNode()
        }

        // Load the sweater model
        let nodeURL = Bundle.main.url(forResource: name2, withExtension: "usdc")!
        let nodeScene = try! SCNScene(url: nodeURL, options: nil)
        let newNode = nodeScene.rootNode
        
        
        //===========SWEATER TEXTURES=================

        //applying logo texture map and coloring
        
        if name2 == "AvatarNodes/Male/Torso/blacksweater" {
            
            if let texture = UIImage(named: "AvatarNodes/Textures/sweaterLogo.png") { //sweaterBaseClr_white.png
                    
                    let material = SCNMaterial()
                    //material.emission.contents = UIColor.blue
                    material.diffuse.contents = texture
                    newNode.childNode(withName: "sweater", recursively: true)?.geometry?.materials = [material]
                
            }
        
        }
        
        
        if name2 == "AvatarNodes/Male/Legs/sweatpants" {
            
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "AvatarNodes/Textures/sweatPantsLogo.png")
            newNode.childNode(withName: "sweatPants_002", recursively: true)?.geometry?.materials = [material]
            
    
        }
        
        if name2 == "AvatarNodes/Male/Torso/MTanktop" {
            
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "AvatarNodes/Textures/LogoTrasnparent.png")
            
            let material2 = SCNMaterial()
            material2.diffuse.contents = UIColor.white
            
            newNode.childNode(withName: "LogoTrasnparent", recursively: true)?.childNode(withName: "LogoTrasnparent", recursively: true)?.geometry?.materials = [material]
            
            newNode.childNode(withName: "Tanktop", recursively: true)?.childNode(withName: "Cube", recursively: true)?.geometry?.materials = [material2]
            
    
        }

        //===========SWEATER TEXTURES=================
        
        scene.rootNode.addChildNode(newNode)
        
    }

    // captures snapshot of scene and assigns to profile page as UIImage
    func takeTheSnapshot() -> UIImage {
        
        let size = CGSize(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
        
        let scnView = SCNView(frame: CGRect(origin: .zero, size: size))
        
        scnView.backgroundColor = UIColor.clear
   
        scnView.scene = scene
        
        // Perform a snapshot

        return scnView.snapshot()

    }


    func updateUIView(_ scnView: SCNView, context: Context) {
        // Update the SCNView if needed
    }



    private func createDirectionalLight(color: UIColor, intensity: CGFloat, position: SCNVector3, direction: SCNVector3) {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional
        lightNode.light?.color = color
        lightNode.light?.intensity = intensity
        lightNode.position = position
        lightNode.eulerAngles = direction
        
        scene.rootNode.addChildNode(lightNode)
        //return lightNode
    }
    
    
    func changeSkinTone(named hexCode: String) {
        
        //apply new hex color to body node
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(hexString: hexCode)
        scene.rootNode.childNode(withName: "Body", recursively: true)?.childNode(withName: "Vert_006", recursively: true)?.geometry?.materials = [material]
        
    }
    
    func changeEyebrow(named hexCode: String) {
        
        //apply new hex color to body node
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(hexString: hexCode)
        scene.rootNode.childNode(withName: "Brows", recursively: true)?.childNode(withName: "Vert_002", recursively: true)?.geometry?.materials = [material]
        
    }
    
    func changeShirtColor(named style: String, named hexCode: String) {
        
        //apply new hex color to body node
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(hexString: hexCode)
        material.specular.contents = UIColor.white
        material.specular.intensity = 0.2
        
        switch style {
            
        case "Shirt":
            
            
            scene.rootNode.childNode(withName: "Shirt", recursively: true)?.childNode(withName: "BSurfaceMesh", recursively: true)?.geometry?.materials = [material]
            
            
        case "Tanktop":
            
            
            scene.rootNode.childNode(withName: "Tanktop", recursively: true)?.childNode(withName: "Cube", recursively: true)?.geometry?.materials = [material]
            
        default:
            
            print("Do nothing")
            
        } //end switch
        
        
        
    }
    
    func changePantsColor(named style: String, named hexCode: String) {
        
        //apply new hex color to body node
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(hexString: hexCode)
        material.specular.contents = UIColor.white
        material.specular.intensity = 0.2
        
        switch style {
            
        case "shorts":
            
            
            scene.rootNode.childNode(withName: "Shorts", recursively: true)?.childNode(withName: "Wye_Joint", recursively: true)?.geometry?.materials = [material]
            
            
        case "pants":
            
            
            scene.rootNode.childNode(withName: "Pants", recursively: true)?.childNode(withName: "Cube_004", recursively: true)?.geometry?.materials = [material]
            
        default:
            
            print("Do nothing")
            
        } //end switch
        
        
        
    }
    
    
    func changeHairColor(named style: String, named hexCode: String) {
        
        //apply new hex color to body node
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(hexString: hexCode)
        
        
        switch style {
            
        case "AnhHair1":
            
            material.specular.contents = UIColor.white
            material.specular.intensity = 0.4
            
            let material2 = SCNMaterial()
            material2.diffuse.contents = UIColor(hexString: hexCode)
            
            scene.rootNode.childNode(withName: "ShortHair", recursively: true)?.childNode(withName: "Plane", recursively: true)?.geometry?.materials = [material2]
            scene.rootNode.childNode(withName: "TopPart", recursively: true)?.childNode(withName: "NurbsPath_001", recursively: true)?.geometry?.materials = [material]
            
            
        case "buzzcut":
            
            scene.rootNode.childNode(withName: "Sphere", recursively: true)?.childNode(withName: "Sphere", recursively: true)?.geometry?.materials = [material]
            
        case "afro":
            
            material.specular.contents = UIColor.white
            material.specular.intensity = 0.4
            
            scene.rootNode.childNode(withName: "hair_sculpted", recursively: true)?.childNode(withName: "Plane_008", recursively: true)?.geometry?.materials = [material]
            
        case "curly":
            
            material.specular.contents = UIColor.white
            material.specular.intensity = 0.4
            scene.rootNode.childNode(withName: "curly_lv1", recursively: true)?.childNode(withName: "Plane_001", recursively: true)?.geometry?.materials = [material]
            
        case "curly2":
            
            material.specular.contents = UIColor.white
            material.specular.intensity = 0.4
            scene.rootNode.childNode(withName: "curly_lv2", recursively: true)?.childNode(withName: "Plane_002", recursively: true)?.geometry?.materials = [material]
            
        case "curly3":
            
            material.specular.contents = UIColor.white
            material.specular.intensity = 0.4
            scene.rootNode.childNode(withName: "curly_lv4", recursively: true)?.childNode(withName: "Plane_004", recursively: true)?.geometry?.materials = [material]
            
        case "shorthair":
            
            scene.rootNode.childNode(withName: "ShortHair", recursively: true)?.childNode(withName: "Plane", recursively: true)?.geometry?.materials = [material]
            
            
        case "mohawk":
            
            scene.rootNode.childNode(withName: "Mohawk_Spikey_Solid", recursively: true)?.childNode(withName: "Cone_003", recursively: true)?.geometry?.materials = [material]
            
        case "longhair":
            
            material.specular.contents = UIColor.white
            material.specular.intensity = 0.4
            
            scene.rootNode.childNode(withName: "NurbsPath", recursively: true)?.childNode(withName: "NurbsPath", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "Sphere_003", recursively: true)?.childNode(withName: "Sphere_004", recursively: true)?.geometry?.materials = [material]
            
        case "elenahair":
            
            material.specular.contents = UIColor.white
            material.specular.intensity = 0.4
            
            scene.rootNode.childNode(withName: "NurbsPath_001", recursively: true)?.childNode(withName: "NurbsPath_004", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_002", recursively: true)?.childNode(withName: "NurbsPath_005", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_003", recursively: true)?.childNode(withName: "NurbsPath_006", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_004", recursively: true)?.childNode(withName: "NurbsPath_007", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_005", recursively: true)?.childNode(withName: "NurbsPath_008", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_006", recursively: true)?.childNode(withName: "NurbsPath_017", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_007", recursively: true)?.childNode(withName: "NurbsPath_010", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_008", recursively: true)?.childNode(withName: "NurbsPath_018", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_009", recursively: true)?.childNode(withName: "NurbsPath_012", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_010", recursively: true)?.childNode(withName: "NurbsPath_013", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_011", recursively: true)?.childNode(withName: "NurbsPath_014", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_012", recursively: true)?.childNode(withName: "NurbsPath_001", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_013", recursively: true)?.childNode(withName: "NurbsPath_002", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_014", recursively: true)?.childNode(withName: "NurbsPath_003", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_015", recursively: true)?.childNode(withName: "NurbsPath_016", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_016", recursively: true)?.childNode(withName: "NurbsPath_019", recursively: true)?.geometry?.materials = [material]
            scene.rootNode.childNode(withName: "NurbsPath_017", recursively: true)?.childNode(withName: "NurbsPath_011", recursively: true)?.geometry?.materials = [material]
           
            
            
            
            
        default:
            
            print("Hello, stranger!")
        }
        
        
    }
   


}

//Scene tests
struct ContentView7: View {
    
    @State private var avatarSnapshot: UIImage?
    @State private var sceneKitView = SceneKitView(named: "CamTest6", skinColor: "#ffdab0")

    var body: some View {
        
        VStack {
            
            sceneKitView
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                .border(Color.blue, width: 2)
            
            
            //avatar image
            if let image = avatarSnapshot {
                
                Image(uiImage: image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.1)
                    .scaleEffect(1.5)
                    .padding(.top, UIScreen.main.bounds.height * 0.05)
                    .zIndex(1)
                
                
            }
            else {
                Text("No image selected")
                    .frame(width: 100, height: 50)
                    .zIndex(1)
            }
            
            
            
            Button(action: {
                
                // Remove the previously added node from the scene
                avatarSnapshot = sceneKitView.takeTheSnapshot()
                
            }) {
                Text("Capture Screenshot")
            }
        
            
            
            
            Button(action: {
                
                sceneKitView.addNode(named: "longhair")
                
            }) {
                Text("Test buzz")
            }
            
            
            Button(action: {
                
                
                sceneKitView.replaceNode(named: "Shirt", named: "Tanktop2")
                
            }) {
                Text("Test sweater")
            }
            
          
                
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.blue)
        
        
        
    } //end body
}

struct SwiftUIView7_Previews: PreviewProvider {
    static var previews: some View {
        ContentView7()
        //SceneKitView6()
    }
}
