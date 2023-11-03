//
//  SwiftUIView5.swift
//  JOYSTIQ
//
//  Created by Connor Sottosanti on 9/17/23.
//

import SwiftUI
import SceneKit

class SceneKitViewModel: ObservableObject {
    
    private var sceneKitView: SceneKitView7?

    func setSceneKitView(_ view: SceneKitView7) {
        sceneKitView = view
    }

    func removeNodeFromScene(_ nodeName: String) {
        
        guard let sceneKitView = sceneKitView else {
            return
        }

        // Call the removeNodeFromScene function on the SceneKitView6 instance
        sceneKitView.removeNodeFromScene(named: nodeName)
    }
}

struct SceneKitView7: UIViewRepresentable {
    
    @State private var AvatarSceneView: SCNView?
    @Binding var avatarSnapshot: UIImage?
    @ObservedObject var viewModel = SceneKitViewModel()
    
    var snapshotButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    func makeUIView(context: Context) -> SCNView {
        // Set up SCNView properties and configuration here
        let scnView = SCNView()
        scnView.backgroundColor = UIColor.clear //lets snapshot be transparent background
        scnView.allowsCameraControl = false
        
        // Set the scene in the SCNView
        let scene = SCNScene()
        scnView.scene = scene
        // Load the Hair model
        let nodeURL = Bundle.main.url(forResource: "CamTest5", withExtension: "usdc")!
        let nodeScene = try! SCNScene(url: nodeURL, options: nil)
        let newNode = nodeScene.rootNode
        
        //add shorts as scene node
        scene.rootNode.addChildNode(newNode)
        
        let lightNode = createDirectionalLight(color: UIColor.white, intensity: 500.0, position: SCNVector3(x: 0, y: 0, z: 0), direction: SCNVector3(Float.pi / 2, 0, 0))
        
        scene.rootNode.addChildNode(lightNode)
        
        // Add the snapshot button and action
        snapshotButton.addTarget(context.coordinator, action: #selector(Coordinator.takeSnapshot), for: .touchUpInside)
        // Set the frame for the button
        snapshotButton.frame = CGRect(x: 16, y: 16, width: 120, height: 40) // Adjust the frame as needed
        scnView.addSubview(snapshotButton)
        
        viewModel.setSceneKitView(self)
        AvatarSceneView = scnView
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update the SceneKit view if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, avatarSnapshot: $avatarSnapshot)
    }
    
    class Coordinator: NSObject {
        var parent: SceneKitView7
        var avatarSnapshot: Binding<UIImage?>

        init(_ parent: SceneKitView7, avatarSnapshot: Binding<UIImage?>) {
            self.parent = parent
            self.avatarSnapshot = avatarSnapshot
        }
        
        @objc func takeSnapshot() {
            
            guard let sceneView = parent.snapshotButton.superview as? SCNView else { return }
            
            // Capture the snapshot of the current scene
            avatarSnapshot.wrappedValue = sceneView.snapshot()
        }
        
    } //end coordinator class
    
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
    
    func removeNodeFromScene(named name: String) {
        
        let nodeToRemove = name
        
        // Access the SCNView's scene and remove the node from it
        if let scene = AvatarSceneView!.scene {
            
            if let nodeToRemove = scene.rootNode.childNode(withName: name, recursively: true) {
                
                nodeToRemove.removeFromParentNode()
                
            }
            
        }
    }

    
    
}

//Usage
struct ContentView7: View {
    
    @State private var avatarSnapshot: UIImage?
    @StateObject private var viewModel = SceneKitViewModel()
    
    var body: some View {
        
        VStack {
            
            SceneKitView7(avatarSnapshot: $avatarSnapshot)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                .border(Color.blue, width: 2)
            
            Button(action: {
                // Remove the previously added node from the scene
                viewModel.removeNodeFromScene("Shirt")
                
            }) {
                Text("Remove Node")
            }
                
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.red)
        
        
        
    } //end body
}

struct SwiftUIView7_Previews: PreviewProvider {
    static var previews: some View {
        ContentView7()
        //SceneKitView6()
    }
}
