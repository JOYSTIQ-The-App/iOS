//
//  SceneKitView.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/10/23.
//
import UIKit
import SceneKit
import ARKit

import SwiftUI

struct ContentView: View {
    
    @State private var isScreenshotTaken = false // State property to trigger screenshot capture
    @State private var snapshot: UIImage?

    
    var body: some View {
        
        VStack {
            
            
            
            ARViewContainer(isScreenshotTaken: $isScreenshotTaken, snapshot: $snapshot)
            
            
            if let image = snapshot {
                
                Image(uiImage: image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.5)
                
                
            }
            else {
                Text("No image selected")
                    .frame(width: 100, height: 50)
            }
            
            
            
            Button(action: {
                // Toggle the isScreenshotTaken property to capture a screenshot
                isScreenshotTaken.toggle()
                
            }) {
                Text("Capture Screenshot")
            }
            
            
            
        } //end main vstack
        .background(.red)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var isScreenshotTaken: Bool // Track whether a screenshot has been taken
    @Binding var snapshot: UIImage?
    
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
        let scene = SCNScene()
        // Create a node to hold the USDZ model
        let usdzNode = SCNNode()
        
        // Load the USDZ model
        if let usdzModelURL = Bundle.main.url(forResource: "MaleTEST", withExtension: "usdc") {
            
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
        
        // Set the scene in the ARSCNView
        uiView.scene = scene
        uiView.backgroundColor = UIColor.clear //lets snapshot be transparent background
        uiView.allowsCameraControl = true
        
        // ARKit configuration setup
       // let configuration = ARWorldTrackingConfiguration()
       //uiView.session.run(configuration)
        
        
       
        let camNode = configureCamera()
        scene.rootNode.addChildNode(camNode)
        
        //----------CAMERA SETUP-----------
        let lightNode = createDirectionalLight(color: UIColor.white, intensity: 500.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(Float.pi / 2, 0, 0))
        
        scene.rootNode.addChildNode(lightNode)
        
        
        // Capture a screenshot when requested
        if isScreenshotTaken {
        
            captureScreenshot(from: uiView) { image in
            // Handle the captured image (e.g., save to the photo library)
            
                
                // Reset the flag
                isScreenshotTaken = false
            }
        }
        
        
    } //end update UIview
    
    // Function to capture a screenshot of the ARSCNView
    private func captureScreenshot(from view: ARSCNView, completion: @escaping (UIImage?) -> Void) {
        //DispatchQueue.main.async {
            let screenshot = view.snapshot()
            self.snapshot = screenshot
            completion(screenshot)
        //}
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
