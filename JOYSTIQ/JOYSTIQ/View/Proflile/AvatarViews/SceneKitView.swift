//
//  SceneKitView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/10/23.
//

import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    
    //@Binding var avatarSnapshot: UIImage?
    
    @State private var nodeToRemoveName: String? = nil
    @State private var nodeToAddName: String? = nil
    
    let scene: SCNScene
    

    init(named name: String) {
        
        
        guard let loadedScene = Self.loadScene(named: name) else {
            fatalError("Failed to load the scene: \(name)")
        }
        
        self.scene = loadedScene

        
        
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
    

    // Working but white background
    
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
    
    //function for removing nodes
    func removeaNode(named name: String) {
        
        nodeToRemoveName = name
        
        if let nodeToRemove = scene.rootNode.childNode(withName: name, recursively: true) {
            nodeToRemove.removeFromParentNode()
        }
        
    }
    
    
    //function for adding nodes
    func addaNode(named name: String) {
        
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

        // Load the Hair model
        let nodeURL = Bundle.main.url(forResource: name2, withExtension: "usdc")!
        let nodeScene = try! SCNScene(url: nodeURL, options: nil)
        let newNode = nodeScene.rootNode
        
        //add shorts as scene node
        scene.rootNode.addChildNode(newNode)
        
        
        
        
        
        
    }
    
    
    func changeSkinTone(named hexCode: String) {
        
        //apply new hex color to body node
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(hexString: hexCode)
        scene.rootNode.childNode(withName: "Body", recursively: true)?.childNode(withName: "Vert_006", recursively: true)?.geometry?.materials = [material]
        
    }
   


}

//Usage
struct ContentView7: View {
    
    @State private var avatarSnapshot: UIImage?
    @State private var sceneKitView = SceneKitView(named: "CamTest6")

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
                
                sceneKitView.removeNode(named: "Shirt")
                
            }) {
                Text("Test Replace")
            }
            
            
            Button(action: {
                
                sceneKitView.addaNode(named: "AvatarNodes/Male/Footwear/sneakers")
                
            }) {
                Text("Test flops")
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
