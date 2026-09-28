//
//  SceneKitView3.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/16/23.
//

import SwiftUI
import SceneKit

struct ContentView4: View {
    
    @State private var avaSnapshot: UIImage?
    
    var body: some View {
        
        VStack {
            
            
            sceneKitViewInstance
                .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.width * 0.6)
            
            if let image = avaSnapshot {
                
                Image(uiImage: image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.width * 0.3)
                
                
            }
            else {
                Text("No image selected")
                    .frame(width: 100, height: 50)
            }
            
            
            
            Button(action: {
                // Take Screenshot
                
                
            }) {
                Text("Capture Screenshot")
            }
            
            
            
        } //end main vstack
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.red)
    }
    
    private var sceneKitViewInstance: SceneKitView4? {
           // Return an instance of SceneKitView3 when needed.
        return SceneKitView4()
       }
    
    /*
    private func captureScreenshot() {
        self.avaSnapshot = sceneKitViewInstance?.takeSnapshot()
      
    } //end captureScreenshot
    */
    
}

struct SceneKitView4: UIViewRepresentable {
    
    //@Binding var avaSnapshot: UIImage?
    //@Binding var scene: SCNScene?

    
    func makeUIView(context: Context) -> SCNView {
        
        let scene = SCNScene()
        
        let scnView = SCNView()
        // Set the scene in the SCNView
        scnView.scene = scene
        scnView.backgroundColor = UIColor.clear //lets snapshot be transparent background
        scnView.allowsCameraControl = false
        
        
        // Create a node to hold the USDZ model
        let usdzNode = SCNNode()
        
        // Load the USDZ model
        if let usdzModelURL = Bundle.main.url(forResource: "CamTest5", withExtension: "usdc") {
            
            do {
                
                let usdzModel = try SCNScene(url: usdzModelURL, options: nil)
                
                for childNode in usdzModel.rootNode.childNodes {
                    
                    usdzNode.addChildNode(childNode)
                    
                }
                
            } catch {
                print("Error loading USDZ model: \(error)")
            }
        }
        
        else {
            print("USDZ model file not found")
        }
        
        // Add the USDZ node to the scene
        scene.rootNode.addChildNode(usdzNode)

        
        let lightNode = createDirectionalLight(color: UIColor.white, intensity: 500.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(Float.pi / 2, 0, 0))
        
        scene.rootNode.addChildNode(lightNode)
        
        
        return scnView
        
    } //end makeUIView
    
    
    
    
    func updateUIView(_ scnView: SCNView, context: Context) {
    
    } //end updateview func

    func takeSnapshot(from scnView: SCNView) -> UIImage? {
            // Perform a snapshot of the provided SCNView
            let snapshot = scnView.snapshot()
            return snapshot
        }
    


    
    private func configureCamera() -> SCNNode {
        
        //----------CAMERA SETUP-----------
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 25 // Adjust this value to change the zoom level (lower value means more zoomed in)
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 8)
        cameraNode.eulerAngles = SCNVector3(x: 0.0, y: 0, z: 0)

        return cameraNode
        
        //let target = SCNVector3(x: 0, y: 0, z: 0)
        //let cameraDirection = SCNVector3(x: 0, y: 0, z: -1)
        //cameraNode.look(at: target, up: SCNVector3(0, 1, 0), localFront: cameraDirection)
        
    }
    
    private func createDirectionalLight(color: UIColor, intensity: CGFloat, position: SCNVector3, direction: SCNVector3) -> SCNNode {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional
        lightNode.light?.color = color
        lightNode.light?.intensity = intensity
        lightNode.position = position
        lightNode.eulerAngles = direction
        
        //scene.rootNode.addChildNode(lightNode)
        return lightNode
    }


}



struct SceneKitView_Previews4: PreviewProvider {
    
    static var previews: some View {
        
        ContentView4()
        
    }
    
}
