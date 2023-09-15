//
//  SceneKitView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/10/23.
//

import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    
    @State private var profileImage: UIImage?
    
    @State private var nodeToRemoveName: String? = nil
    @State private var nodeToAddName: String? = nil
    
    
    
    
    let scene: SCNScene
    

    init(named name: String) {
        
        
        guard let loadedScene = Self.loadScene(named: name) else {
            fatalError("Failed to load the scene: \(name)")
        }
        self.scene = loadedScene
        
        //configureCamera()
      
        
        //create light nodes
        
        createDirectionalLight(color: UIColor.white, intensity: 500.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(-Float.pi / 2, 0, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 500.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(Float.pi / 2, 0, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 200.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(0, 0, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 500.0, position: SCNVector3(x: 0, y: -Float.pi / 2, z: 0), direction: SCNVector3(0, -Float.pi / 2, 0))
        
        createDirectionalLight(color: UIColor.white, intensity: 500.0, position: SCNVector3(x: 0, y: Float.pi / 2, z: 0), direction: SCNVector3(0, Float.pi / 2, 0))
        
  
     
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

    func makeUIView(context: Context) -> SCNView {
        
        let scnView = SCNView()
    
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.clear
        
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
    

    //function for adding nodes
    func takeSnapshot() -> UIImage {
        
        let size = CGSize(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
        
        let scnView = SCNView(frame: CGRect(origin: .zero, size: size))
        scnView.scene = scene
        
        scnView.backgroundColor = UIColor.clear
        scene.background.contents = UIColor.clear
        scene.lightingEnvironment.contents = UIColor.clear
        scnView.isOpaque = true
        
        
        // Perform a snapshot
        let snapshot = scnView.snapshot()

            
        return snapshot
        
    }



    
    func updateUIView(_ scnView: SCNView, context: Context) {
        // Update the SCNView if needed
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
   

    
    /*
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


struct SceneKitView_Previews: PreviewProvider {
    static var previews: some View {
        SceneKitView(named: "skintone6")
    }
}
